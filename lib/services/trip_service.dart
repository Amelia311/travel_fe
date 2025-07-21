import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TripService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // Ambil token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<bool> createTrip(String title, DateTime date) async {
    final token = await getToken(); // Ambil token dulu
    if (token == null) {
      print('Token tidak ditemukan!');
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/trips'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'date': date.toIso8601String(),
      }),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    return response.statusCode == 201;
  }

  static Future<List<Map<String, dynamic>>> getTrips() async {
    final token = await getToken(); // Ambil token juga di sini
    if (token == null) {
      print('Token tidak ditemukan!');
      throw Exception('Unauthorized');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/trips'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
    } else {
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      throw Exception('Failed to load trips');
    }
  }

  static Future<List<dynamic>> fetchItineraries(int tripId) async {
  final token = await getToken();
  final response = await http.get(
    Uri.parse('$baseUrl/trips/$tripId/itineraries'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', 
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load itineraries');
  }
}

}
