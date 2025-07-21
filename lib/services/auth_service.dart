import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Register Error: ${response.body}");
      return false;
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    print("Mulai login...");
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {
        'email': email,
        'password': password,
      },
    ).timeout(const Duration(seconds: 10));

    print("Respon diterima: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Data response: $data");

      // ✅ Ubah dari access_token ke token
      final token = data['token'];

      if (token == null) {
        throw Exception("Token tidak ditemukan di respons!");
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      print('Token disimpan: $token');

      return {'success': true, 'data': data};
    } else {
      final data = json.decode(response.body);
      return {
        'success': false,
        'message': data['message'] ?? 'Login gagal'
      };
    }
  }
}
