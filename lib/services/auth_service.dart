import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconnet_internship_mobile/models/auth_respone.dart';
import 'package:iconnet_internship_mobile/services/cookie_service.dart';
import 'package:iconnet_internship_mobile/services/dio_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final Dio _dio = createDio();

  Future<AuthResponse> login(String identifier, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'identifier': identifier,
          'password': password,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        final responseBody = response.data;
        String token = responseBody['token'];

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        // Menyimpan cookies di CookieService
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          final cookieService = CookieService();
          cookieService.addCookies(response);
        }

        return AuthResponse.fromJson(responseBody);
      } else {
        final errorResponse = response.data;
        throw Exception(errorResponse['message'] ?? 'Failed to login');
      }
    } catch (e) {
      print('Exception caught: $e');
      rethrow;
    }
  }

  Future<AuthResponse> register(String username, String email, String password, String confirmPass, int roleId) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'confirmPass': confirmPass,
          'role_id': roleId,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.data;
        return AuthResponse.fromJson(responseBody);
      } else {
        final errorResponse = response.data;
        throw Exception(errorResponse['message'] ?? 'Failed to register');
      }
    } catch (e) {
      print('Exception caught: $e');
      rethrow;
    }
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token == null) return false;

    bool isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('roleId');
    await prefs.remove('cookies'); 

    final cookieService = CookieService();
    cookieService.clearAllCookies();
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.get(
        '/user/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Exception caught: $e');
      rethrow;
    }
  }

    Future<Map<String, dynamic>> getApplicantByUserId(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.get(
        '/applicant/user/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
       final data = response.data['data'];

      return {
        ...data,
        'photoUrl': data['photo'], 
        'educationTranscriptUrl': data['education_transcript'], 

      };
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Exception caught: $e');
      rethrow;
    }
  }

    Future<void> updateUsername(String newUsername) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await _dio.put(
        '/user/updateUsername',
        data: {
          'newUsername': newUsername,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        await prefs.setString('authToken', newToken);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update username');
      }
    } catch (e) {
      print('Exception caught: $e');
      rethrow;
    }
  }

    Future<void> updatePassword(
      String oldPassword, String newPassword, String confirmNewPass) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      final response = await _dio.put(
        '/user/updatePassword',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmNewPass': confirmNewPass,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Handle successful password update
        print('Password updated successfully');
      } else {
        // Handle failure cases
        print('Failed to update password: ${response.data['message']}');
      }
    } catch (e) {
      print('Error updating password: $e');
    }
  }
}
