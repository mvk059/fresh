import 'dart:convert';

import 'package:http/http.dart' as http;

import 'network_interface.dart';

class NetworkImpl implements NetworkInterface {
  final String baseUrl = 'https://www.example.com';

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> syncCoordinates(
      List<Map<String, dynamic>> coordinates) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sync_coordinates'),
      body: json.encode(coordinates),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to sync coordinates');
    }
  }
}
