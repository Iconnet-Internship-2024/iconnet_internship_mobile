import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconnet_internship_mobile/services/dio_service.dart';
import 'dart:io';

class ApplicantService {
  final Dio _dio = createDio();

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

  Future<Map<String, dynamic>> addApplicant({
    required String name,
    required String placeOfBirth,
    required String dateOfBirth,
    required String gender,
    required String phoneNumber,
    required String city,
    required String address,
    required String religion,
    required String educationDegree,
    required String studentId,
    required String educationInstitution,
    required String educationMajor,
    required String educationFaculty,
    required String photoPath,
    required String educationTranscriptPath,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        throw Exception('Token not found');
      }

      final formData = FormData.fromMap({
        'name': name,
        'place_of_birth': placeOfBirth,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'phone_number': phoneNumber,
        'city': city,
        'address': address,
        'religion': religion,
        'education_degree': educationDegree,
        'student_id': studentId,
        'education_institution': educationInstitution,
        'education_major': educationMajor,
        'education_faculty': educationFaculty,
        'photo': await MultipartFile.fromFile(photoPath, filename: 'photo.jpg'),
        'education_transcript': await MultipartFile.fromFile(educationTranscriptPath, filename: 'transcript.pdf'),
      });

      final response = await _dio.post(
        '/applicant',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to add applicant');
      }
    } catch (e) {
      print('Exception caught: $e');
      rethrow;
    }
  }
}
