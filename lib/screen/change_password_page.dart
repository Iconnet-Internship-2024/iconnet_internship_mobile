import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:iconnet_internship_mobile/services/auth_service.dart';
import 'package:iconnet_internship_mobile/screen/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  String _username = '';
  String _email = '';
  String? _photoUrl = '';
  bool _isLoading = true;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _submitted = false;
  int _selectedIndex = 2;

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

        setState(() {
          _username = userData['username'];
          _email = userData['email'];
          _photoUrl = photoUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
      if (e is DioError && e.response?.statusCode == 401) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  void _togglePasswordVisibility(TextEditingController controller) {
    setState(() {
      if (controller == _currentPasswordController) {
        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
      } else if (controller == _newPasswordController) {
        _isNewPasswordVisible = !_isNewPasswordVisible;
      } else if (controller == _confirmPasswordController) {
        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
      }
    });
  }

  void _updatePassword() async {
    setState(() {
      _submitted = true; // Mark the form as submitted
    });

    final oldPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmNewPass = _confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmNewPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    if (newPassword != confirmNewPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password baru dan konfirmasi tidak sama')),
      );
      return;
    }

    // Panggil API update password
    try {
      await _authService.updatePassword(oldPassword, newPassword, confirmNewPass);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password berhasil diubah')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah password: $e')),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            ? const Center(child: CircularProgressIndicator())
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
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Password Saat Ini',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildPasswordField(
                            hint: 'Masukkan password saat ini',
                            controller: _currentPasswordController,
                            isObscured: !_isCurrentPasswordVisible,
                            onVisibilityToggle: () => _togglePasswordVisibility(_currentPasswordController),
                            errorText: _submitted && _currentPasswordController.text.isEmpty ? 'Password saat ini harus diisi' : null,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Password Baru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildPasswordField(
                            hint: 'Masukkan password baru',
                            controller: _newPasswordController,
                            isObscured: !_isNewPasswordVisible,
                            onVisibilityToggle: () => _togglePasswordVisibility(_newPasswordController),
                            errorText: _submitted && _newPasswordController.text.isEmpty ? 'Password baru harus diisi' : null,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Ulangi Password Baru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildPasswordField(
                            hint: 'Ulangi password baru',
                            controller: _confirmPasswordController,
                            isObscured: !_isConfirmPasswordVisible,
                            onVisibilityToggle: () => _togglePasswordVisibility(_confirmPasswordController),
                            errorText: _submitted && _confirmPasswordController.text.isEmpty ? 'Ulangi password harus diisi' : null,
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _updatePassword,
                                child: const Text(
                                  'Ubah Password',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildPasswordField({
    required String hint,
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onVisibilityToggle,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isObscured,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: onVisibilityToggle,
            ),
            errorText: errorText,
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
