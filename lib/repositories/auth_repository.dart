import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:machine_test_practice/services/storage_service.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response =
          await http.post(Uri.parse('https://dummyjson.com/auth/login'),
              headers: {
                "Content-Type": "application/json",
              },
              body: jsonEncode({"username": username, "password": password}));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      final storageService = StorageService();
      await storageService.clearAccessToken();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
