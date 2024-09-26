import 'dart:convert';
import 'package:http/http.dart' as http;

class KunjunganService {
  final String apiUrl = "https://codenebula.my.id/api/kunjungan/dashboard/all";

  Future<List<dynamic>> fetchKunjungan(String token) async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);
        List<dynamic> kunjungan;
        if (decodedResponse is Map) {
          kunjungan = decodedResponse['data'] ?? [];
        } else if (decodedResponse is List) {
          kunjungan = decodedResponse;
        } else {
          throw Exception('Unexpected response format');
        }
        print('Data berhasil diambil!');
        return kunjungan;
      } else {
        throw Exception('Failed to load kunjungan');
      }
    } catch (e) {
      throw Exception('Failed to fetch kunjungan: $e');
    }
  }
}
