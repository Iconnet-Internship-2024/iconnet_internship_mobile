import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconnet_internship_mobile/models/auth_respone.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:3000';

  Future<AuthResponse> login(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      return authResponse;
    } else {
      final errorResponse = AuthResponse.fromJson(jsonDecode(response.body));
      throw Exception(errorResponse.message); // Tangani error dengan lebih baik
    }
    } catch (e) {
      print('Exception caught: $e');
      rethrow;
    }
  }

Future<AuthResponse> register(String username, String email, String password, String confirmPass, int roleId) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'email': email,
      'password': password,
      'confirmPass': confirmPass,
      'role_id': roleId, 
    }),
  );

  if (response.statusCode == 200) {
    return AuthResponse.fromJson(jsonDecode(response.body));
  } else {
    final errorResponse = jsonDecode(response.body);
    throw Exception(errorResponse['message'] ?? 'Failed to register');
  }
}
}