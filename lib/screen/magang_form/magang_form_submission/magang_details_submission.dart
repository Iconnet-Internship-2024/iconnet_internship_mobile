import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/services/submission_service.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_applicant/magang_details_applicant.dart';
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart'; 
import 'package:iconnet_internship_mobile/screen/SK_page.dart'; 
import 'package:iconnet_internship_mobile/screen/profile_page.dart'; 
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmissionDetailsScreen extends StatefulWidget {
  @override
  _SubmissionDetailsScreenState createState() => _SubmissionDetailsScreenState();
}

class _SubmissionDetailsScreenState extends State<SubmissionDetailsScreen> {
  final SubmissionService _submissionService = SubmissionService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  bool _isSubmissionExists = true;
  int _selectedIndex = 0;

  String? _jobDivision;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _coverLetterUrl;
  String? _proposalUrl;

  @override
  void initState() {
    super.initState();
    _checkSubmissionData();
  }

  Future<void> _checkSubmissionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int userId = decodedToken['userId'];

        final submissionData = await _submissionService.getSubmissionByUserId(userId);

        if (submissionData.isNotEmpty) {
          setState(() {
            _jobDivision = _getJobDivisionName(submissionData['job_division_id']);
            _startDate = DateTime.tryParse(submissionData['start_date'] ?? '');
            _endDate = DateTime.tryParse(submissionData['end_date'] ?? '');
            _coverLetterUrl = submissionData['coverLetterUrl'];
            _proposalUrl = submissionData['proposalUrl'];
            _isSubmissionExists = true;
          });
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

  String _getJobDivisionName(int jobDivisionId) {
    switch (jobDivisionId) {
      case 1:
        return 'Default';
      case 2:
        return 'Engineering';
      case 3:
        return 'Marketing';
      case 4:
        return 'Human Resources';
      case 5:
        return 'Sales';
      default:
        return 'Unknown Division';
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
          MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
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
                      'Detail Data Ajuan',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: primaryColors,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _buildDetailField(label: 'Divisi', value: _jobDivision ?? ''),
                  const SizedBox(height: 20.0),
                  _buildDetailField(
                      label: 'Tanggal Mulai',
                      value: _startDate != null
                          ? DateFormat('dd-MM-yyyy').format(_startDate!)
                          : ''),
                  const SizedBox(height: 20.0),
                  _buildDetailField(
                      label: 'Tanggal Selesai',
                      value: _endDate != null
                          ? DateFormat('dd-MM-yyyy').format(_endDate!)
                          : ''),
                  const SizedBox(height: 20.0),
                  _buildImageSection(label: 'Surat Pengantar', url: _coverLetterUrl),
                  const SizedBox(height: 20.0),
                  _buildImageSection(label: 'Proposal', url: _proposalUrl),
                  const SizedBox(height: 30.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ApplicantDetailsScreen()),
                        );
                      },
                      child: Text('Kembali'),
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
