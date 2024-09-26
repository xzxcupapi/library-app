import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/books_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:data_table_2/data_table_2.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).loadBooks();
    });
  }

  void _sort<T>(Comparable<T> Function(dynamic book) getField, int columnIndex, bool ascending) {
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
        borderRadius: BorderRadius.circular(14),
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
        title: const Text('Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<BookProvider>(context, listen: false).loadBooks(),
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

          return Theme(
            data: Theme.of(context).copyWith(
              cardTheme: CardTheme(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              ),
            ),
            child: Card(
              margin: const EdgeInsets.all(10.0),
              child: PaginatedDataTable2(
                source: BookDataTableSource(bookProvider.books, _buildStatusBadge),
                header: const Text('Book List'),
                columns: [
                  DataColumn2(
                    label: const Text('Judul'),
                    onSort: (columnIndex, ascending) =>
                        _sort<String>((book) => book['judul'], columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('Pengarang'),
                    onSort: (columnIndex, ascending) =>
                        _sort<String>((book) => book['pengarang'], columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('Status'),
                    onSort: (columnIndex, ascending) =>
                        _sort<String>((book) => book['status'], columnIndex, ascending),
                  ),
                ],
                rowsPerPage: _rowsPerPage,
                onRowsPerPageChanged: (value) {
                  setState(() {
                    _rowsPerPage = value!;
                  });
                },
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                empty: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.grey[200],
                    child: const Text('No data'),
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

class BookDataTableSource extends DataTableSource {
  final List<dynamic> _books;
  final Widget Function(String) _buildStatusBadge;

  BookDataTableSource(this._books, this._buildStatusBadge);

  @override
  DataRow? getRow(int index) {
    if (index >= _books.length) return null;
    final book = _books[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(book['judul'] ?? '')),
        DataCell(Text(book['pengarang'] ?? '')),
        DataCell(_buildStatusBadge(book['status'] ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _books.length;

  @override
  int get selectedRowCount => 0;
}