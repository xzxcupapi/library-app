import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/books_provider.dart';
import 'package:data_table_2/data_table_2.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).loadBooks();
    });
  }

  void _sort<T>(Comparable<T> Function(dynamic book) getField, int columnIndex,
      bool ascending) {
    Provider.of<BookProvider>(context, listen: false).sortBooks((a, b) {
      if (!ascending) {
        final temp = a;
        a = b;
        b = temp;
      }
      final aValue = getField(a);
      final bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void _showBookDetails(String title, String pengarang, String penerbit, String tahun_terbit, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Detail Buku"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Judul:\n $title"),
              SizedBox(height: 2),
              Text("Pengarang:\n $pengarang"),
              SizedBox(height: 2),
              Text('Penerbit: \n $penerbit'),
              SizedBox(height: 2),
              Text('Tahun Terbit: \n $tahun_terbit'),
              SizedBox(height: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Status: "),
                  SizedBox(height: 2),
                  _buildStatusBadge(status),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;
    String displayText;

    switch (status.toLowerCase()) {
      case 'dipinjam':
        backgroundColor = Colors.yellow[700]!;
        textColor = Colors.white;
        displayText = 'Dipinjam';
        break;
      case 'tersedia':
        backgroundColor = Colors.green[600]!;
        displayText = 'Tersedia';
        break;
      default:
        backgroundColor = Colors.grey[600]!;
        displayText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                Provider.of<BookProvider>(context, listen: false).loadBooks(),
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (ctx, bookProvider, _) {
          if (bookProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bookProvider.error != null) {
            return Center(child: Text('Error: ${bookProvider.error}'));
          }

          if (bookProvider.books.isEmpty) {
            return const Center(child: Text('No books available'));
          }

          return SingleChildScrollView(
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text('Daftar Buku',
                          style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 10),
                      DataTable(
                        columns: [
                          DataColumn(
                            label: const Text('Judul'),
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (book) => book['judul'],
                                columnIndex,
                                ascending),
                          ),
                          DataColumn(
                            label: const Text('Status'),
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (book) => book['status'],
                                columnIndex,
                                ascending),
                          ),
                        ],
                        rows: bookProvider.books.map<DataRow>((book) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(book['judul'] ?? ''),
                                onTap: () {
                                  _showBookDetails(
                                      book['judul'] ?? '',
                                      book['pengarang'] ?? '',
                                      book['penerbit'] ?? '',
                                      book['tahun_terbit'] ?? '',
                                      book['status'] ?? '');
                                },
                              ),
                              DataCell(_buildStatusBadge(book['status'] ?? '')),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
