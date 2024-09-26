import 'dart:async';
import '../../lib/services/kunjungan_service.dart';

void main() async {
  final kunjunganService = KunjunganService();
  String token = "token_bearer_login";

  try {
    List<dynamic> kunjungan = await kunjunganService.fetchKunjungan(token);

    print('Data Kunjungan:');
    for (var item in kunjungan) {
      print(item);
    }
  } catch (e) {
    print('Error: $e');
  }
}
