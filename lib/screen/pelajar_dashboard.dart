import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconnet_internship_mobile/services/applicant_service.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart'; // Pastikan pathnya benar
import 'package:iconnet_internship_mobile/screen/pkl_form/pkl_form_applicant/pkl_details_applicant.dart';
import 'package:iconnet_internship_mobile/screen/pkl_form/pkl_form_applicant/pkl_applicant_form.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';

class PelajarDashboard extends StatefulWidget {
  const PelajarDashboard({Key? key}) : super(key: key);

  @override
  State<PelajarDashboard> createState() => _MahasiswaDashboardState();
}

class _MahasiswaDashboardState extends State<PelajarDashboard> {
  final ApplicantService _applicantService = ApplicantService();
  bool _isLoading = true;
  bool _isApplicantExists = false;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

        setState(() {
          _isApplicantExists = applicantData.isNotEmpty;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load applicant data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return (await Navigator.of(context).maybePop()) || false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _isApplicantExists
                                ? ApplicantDetailsScreen()
                                : ApplicantFormScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school,
                                size: 80,
                                color: Colors.black,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'PKL',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Tambahkan lebih banyak card sesuai kebutuhan
                  ],
                ),
              ),
        drawer: Navbar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}