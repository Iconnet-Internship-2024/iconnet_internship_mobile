import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/services/submission_service.dart';
import 'package:iconnet_internship_mobile/services/applicant_service.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:iconnet_internship_mobile/screen/pkl_form/pkl_form_submission/magang_details_submission.dart';
import 'package:iconnet_internship_mobile/screen/pkl_form/pkl_form_submission/magang_form_submission.dart';
import 'package:iconnet_internship_mobile/screen/pelajar_dashboard.dart';
import 'package:iconnet_internship_mobile/screen/SK_page.dart';
import 'package:iconnet_internship_mobile/screen/profile_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicantDetailsScreen extends StatefulWidget {
  @override
  _ApplicantDetailsScreenState createState() => _ApplicantDetailsScreenState();
}

class _ApplicantDetailsScreenState extends State<ApplicantDetailsScreen> {
  final ApplicantService _applicantService = ApplicantService();
  final SubmissionService _submissionService = SubmissionService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  bool _isApplicantExists = false;
  bool _isSubmissionExists = false;
  int _selectedIndex = 0;

  // Applicant details
  DateTime? _birthDate;
  String _name = '';
  String _placeOfBirth = '';
  String _phoneNumber = '';
  String _city = '';
  String _address = '';
  String _studentId = '';
  String _educationInstitution = '';
  String _educationMajor = '';
  String _educationDegree = '';
  String? _photoUrl;
  String? _educationTranscriptUrl;

  @override
  void initState() {
    super.initState();
    _checkApplicantData();
  }

  Future<void> _checkApplicantData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int userId = decodedToken['userId'];

        final applicantData = await _applicantService.getApplicantByUserId(userId);

        if (applicantData.isNotEmpty) {
          setState(() {
            _name = applicantData['name'] ?? '';
            _placeOfBirth = applicantData['place_of_birth'] ?? '';
            _birthDate = DateTime.tryParse(applicantData['date_of_birth'] ?? '');
            _phoneNumber = applicantData['phone_number'] ?? '';
            _city = applicantData['city'] ?? '';
            _address = applicantData['address'] ?? '';
            _studentId = applicantData['student_id'] ?? '';
            _educationInstitution = applicantData['education_institution'] ?? '';
            _educationMajor = applicantData['education_major'] ?? '';
            _educationDegree = applicantData['education_degree'] ?? '';
            _photoUrl = applicantData['photoUrl'];
            _educationTranscriptUrl = applicantData['educationTranscriptUrl'];
            _isApplicantExists = true;
          });

          // Check if submission data exists
          final submissionData = await _submissionService.getSubmissionByUserId(userId);
          if (submissionData.isNotEmpty) {
            setState(() {
              _isSubmissionExists = true;
            });
          }
        }
      }
    } catch (e) {
      print('Failed to load applicant data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on selected index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PelajarDashboard()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SKPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColors,
        title: const Text(
          'PLN Icon Plus Internship',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          color: Colors.white,
        ),
      ),
      drawer: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Detail Data Pelamar',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: primaryColors,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _buildDetailField(label: 'Nama', value: _name),
                  const SizedBox(height: 20.0),
                  _buildDetailField(label: 'Tempat Lahir', value: _placeOfBirth),
                  const SizedBox(height: 20.0),
                  _buildDetailField(
                      label: 'Tanggal Lahir',
                      value: _birthDate != null
                          ? DateFormat('dd-MM-yyyy').format(_birthDate!)
                          : ''),
                  _buildDetailField(label: 'No. Telepon', value: _phoneNumber),
                  const SizedBox(height: 20.0),
                  _buildDetailField(label: 'Kota', value: _city),
                  const SizedBox(height: 20.0),
                  _buildDetailField(label: 'Alamat', value: _address),
                  const SizedBox(height: 20.0),
                  _buildDetailField(label: 'NIM', value: _studentId),
                  const SizedBox(height: 20.0),
                  _buildDetailField(label: 'Jenjang Pendidikan', value: _educationDegree),
                  const SizedBox(height: 20.0),
                  _buildDetailField(
                      label: 'Institusi Pendidikan', value: _educationInstitution),
                  _buildDetailField(label: 'Jurusan', value: _educationMajor),
                  const SizedBox(height: 20.0),
                  _buildImageSection(label: 'Foto', url: _photoUrl),
                  const SizedBox(height: 20.0),
                  _buildImageSection(label: 'Transkrip Pendidikan', url: _educationTranscriptUrl),
                  const SizedBox(height: 30.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        if (_isSubmissionExists) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SubmissionDetailsScreen()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SubmissionFormScreen()),
                          );
                        }
                      },
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(text: value),
        readOnly: true,
      ),
    );
  }

  Widget _buildImageSection({required String label, String? url}) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        if (url != null)
          GestureDetector(
            onTap: () => _launchUrl(url),
            child: Text(
              'Lihat $label',
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          )
        else
          Text('Tidak ada $label'),
      ],
    );
  }
}
