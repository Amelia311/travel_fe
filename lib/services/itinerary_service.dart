import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class ItineraryService {
  static const baseUrl = 'http://127.0.0.1:8000/api'; // sesuaikan ip kamu

  // Ambil token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }


static Future<List<Map<String, dynamic>>> getItineraries(int tripId) async {
  final token = await getToken();

  if (token == null) {
    throw Exception('Token tidak ditemukan!');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/trips/$tripId/itineraries'),
    headers: {'Authorization': 'Bearer $token'}, // ← pakai token!
  );

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Gagal mengambil data itinerary');
  }
}

  static Future<bool> addItinerary(Map<String, dynamic> data) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/itineraries'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token',},
      body: json.encode(data),
    );
    return response.statusCode == 201;
  }

  static Future<bool> deleteItinerary(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/itineraries/$id'));
    return response.statusCode == 200;
  }
}
