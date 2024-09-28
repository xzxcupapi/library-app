import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/kunjungan_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KunjunganScreen extends StatefulWidget {
  const KunjunganScreen({super.key});

  @override
  _KunjunganScreenState createState() => _KunjunganScreenState();
}

class _KunjunganScreenState extends State<KunjunganScreen> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndKunjungan();
  }

  Future<void> _loadTokenAndKunjungan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    if (token != null) {
      Provider.of<KunjunganProvider>(context, listen: false)
          .loadKunjungan(token!);
    } else {
      print("Token tidak ditemukan!");
    }
  }

  void _sort<T>(Comparable<T> Function(dynamic kunjungan) getField,
      int columnIndex, bool ascending) {
    Provider.of<KunjunganProvider>(context, listen: false)
        .sortKunjungan((a, b) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Management'),
        actions: [
          IconButton(
            onPressed: () {
              if (token != null) {
                Provider.of<KunjunganProvider>(context, listen: false)
                    .loadKunjungan(token!);
              }
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Consumer<KunjunganProvider>(builder: (ctx, kunjunganProvider, _) {
        if (kunjunganProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (kunjunganProvider.error != null) {
          return Center(child: Text('Error: ${kunjunganProvider.error}'));
        }

        if (kunjunganProvider.kunjungan.isEmpty) {
          return const Center(child: Text('Tidak Ada Data Kunjungan'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text('Daftar Kunjungan',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10),
                    DataTable(
                      columnSpacing: 10,
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: 200,
                            child: const Text('Nama Mahasiswa'),
                          ),
                          onSort: (columnIndex, ascending) => _sort<String>(
                            (kunjungan) => kunjungan['nama_mahasiswa'],
                            columnIndex,
                            ascending,
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 100,
                            child: const Text('Tgl Kunjungan'),
                          ),
                          onSort: (columnIndex, ascending) => _sort<String>(
                            (kunjungan) => kunjungan['tanggal_kunjungan'],
                            columnIndex,
                            ascending,
                          ),
                        ),
                      ],
                      rows:
                          kunjunganProvider.kunjungan.map<DataRow>((kunjungan) {
                        return DataRow(
                          cells: [
                            DataCell(SizedBox(
                              width: 200,
                              child: Text(kunjungan['nama_mahasiswa'] ?? ''),
                            )),
                            DataCell(SizedBox(
                              width: 100,
                              child: Text(kunjungan['tanggal_kunjungan'] ?? ''),
                            )),
                          ],
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
