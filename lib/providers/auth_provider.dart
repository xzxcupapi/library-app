import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static const String _apiUrl = 'https://codenebula.my.id/api';
  String _token = '';

  String get token => _token;

  void setToken(String newToken) {
    _token = newToken;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$_apiUrl/login');
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('access_token')) {
        _token = data['access_token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token);
        notifyListeners();
        return null;
      } else {
        return 'Access token tidak ditemukan dalam respons.';
      }
    } else {
      final data = json.decode(response.body);
      print('Response data: $data');
      return data['message'] ?? 'Login gagal, silakan coba lagi.';
    }
  }

  Future<String> logout(BuildContext context) async {
    _token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();

    return 'Logout Berhasil';
  }

  Future<void> tryAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return;

    final token = prefs.getString('token');
    if (token != null) {
      _token = token;
      notifyListeners();
    }
  }
}
