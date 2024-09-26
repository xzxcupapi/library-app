import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  final String apiUrl = "https://codenebula.my.id/api/buku/dashboard/all";

  Future<List<dynamic>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);
        List<dynamic> books;
        if (decodedResponse is Map) {
          books = decodedResponse['data'] ?? [];
        } else if (decodedResponse is List) {
          books = decodedResponse;
        } else {
          throw Exception('Unexpected response format');
        }
        print('Data berhasil diambil');
        return books;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Failed to fetch books: $e');
    }
  }
}