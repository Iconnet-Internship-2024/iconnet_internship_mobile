import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconnet_internship_mobile/services/dio_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SubmissionService {
  final Dio _dio = createDio();

  Future<Map<String, dynamic>> getSubmissionByUserId(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.get(
        '/submission/user/$userId',
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
        'coverLetterUrl': data['cover_letter'], 
        'proposalUrl': data['proposal'], 
      };
      } else {
        throw Exception('Failed to load user data');
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
}