import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart';
import 'package:iconnet_internship_mobile/screen/SK_page.dart';
import 'package:iconnet_internship_mobile/screen/edit_profile_page.dart';
import 'package:iconnet_internship_mobile/screen/change_password_page.dart';
import 'package:iconnet_internship_mobile/screen/first_screen.dart';
import 'package:iconnet_internship_mobile/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:iconnet_internship_mobile/screen/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService();
  String _username = '';
  String _email = '';
  String? _status;
  String? _photoUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  
  Future<void> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int userId = decodedToken['userId'];
        final userData = await _authService.getUserById(userId);

        String? photoUrl;
        try {
          final applicantData = await _authService.getApplicantByUserId(userId);
          photoUrl = applicantData['photoUrl'];
        } catch (e) {
          if (e is DioError && e.response?.statusCode == 404) {
            photoUrl = null;
          } else {
            throw e;
          }
        }

        String? status;
        try {
          final submissionData = await _authService.getSubmissionByUserId(userId);
          status = submissionData['status'];
        } catch (e) {
          if (e is DioError && e.response?.statusCode == 404) {
            status = null;
          } else {
            throw e;
          }
        }

        setState(() {
          _username = userData['username'];
          _email = userData['email'];
          _status = status;
          _photoUrl = photoUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
      if (e is DioError && e.response?.statusCode == 401) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SKPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FirstScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed, please try again.')),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return false;
    }
    return true;
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
                  children: [
                    Container(
                      width: double.infinity,
                      height: 220,
                      padding: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        color: primaryColors,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: _photoUrl != null
                                ? NetworkImage(_photoUrl!)
                                : null,
                            child: _photoUrl == null
                                ? Center(
                                    child: const Text(
                                      "Belum ada foto",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _username,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildStatusOption(
                    context,
                    icon: Icons.notifications,
                    status: _status,
                  ),
                    _buildProfileOption(
                      context,
                      icon: Icons.edit,
                      text: 'Edit Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfilePage()),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.lock,
                      text: 'Ubah Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.logout,
                      text: 'Logout',
                      onTap: () {
                        _logout(); 
                      },
                    ),
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

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon, required String text, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColors),
            const SizedBox(width: 16),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

    Widget _buildStatusOption(BuildContext context,
      {required IconData icon, required String? status}) {
    Color statusColor;
    String statusText;

    switch (status) {
      case 'pending':
        statusColor = Colors.orange; 
        statusText = 'Menunggu diproses';
        break;
      case 'in_process':
        statusColor = Colors.blue;
        statusText = 'Sedang diproses';
        break;
      case 'accepted':
        statusColor = Colors.green; 
        statusText = 'Diterima';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Ditolak';
        break;
      default:
        statusColor = Colors.black;
        statusText = 'Form belum diisi dengan lengkap';
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: statusColor),
          const SizedBox(width: 16),
          Text(
            statusText,
            style: TextStyle(fontSize: 16, color: statusColor),
          ),
        ],
      ),
    );
  }
}
