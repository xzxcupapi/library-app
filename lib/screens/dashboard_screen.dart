import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int availableBooks = 0;
  int borrowedBooks = 0;
  int lostBooks = 0;
  bool isLoading = true;

  final String apiUrl = "https://codenebula.my.id/api/buku/dashboard/all";

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);
        List<dynamic> books = [];

        if (decodedResponse is Map) {
          books = decodedResponse['data'] ?? [];
        } else if (decodedResponse is List) {
          books = decodedResponse;
        }

        int available = 0;
        int borrowed = 0;
        int lost = 0;

        for (var book in books) {
          if (book['status'] == 'tersedia') {
            available++;
          } else if (book['status'] == 'dipinjam') {
            borrowed++;
          } else if (book['status'] == 'hilang') {
            lost++;
          }
        }

        setState(() {
          availableBooks = available;
          borrowedBooks = borrowed;
          lostBooks = lost;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Management'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildGridItem(
                    context,
                    'Buku Tersedia',
                    Icons.check_circle,
                    Colors.green,
                    availableBooks,
                  ),
                  const SizedBox(height: 20),
                  _buildGridItem(
                    context,
                    'Buku Dipinjam',
                    Icons.remove_circle,
                    Colors.yellow,
                    borrowedBooks,
                  ),
                  const SizedBox(height: 20),
                  _buildGridItem(
                    context,
                    'Buku Hilang',
                    Icons.report_problem,
                    Colors.red,
                    lostBooks,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon,
      Color iconColor, int count) {
    return GestureDetector(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: iconColor),
              const SizedBox(height: 20),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                count.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
