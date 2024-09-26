import 'package:flutter/material.dart';
import '../services/kunjungan_service.dart';

class KunjunganProvider with ChangeNotifier{
  List<dynamic>_kunjungan = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get kunjungan => _kunjungan;

  bool get isLoading => _isLoading;

  String? get error => _error;

  final KunjunganService _kunjunganService = KunjunganService();

  Future<void> loadKunjungan(String token) async{
    _isLoading = true;
    _error = null;
    notifyListeners();
    try{
      _kunjungan = await _kunjunganService.fetchKunjungan(token);
    } catch (e){
      _error = e.toString();
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sortKunjungan(int Function (dynamic a, dynamic b)compare){
    _kunjungan.sort(compare);
    notifyListeners();
  }
}