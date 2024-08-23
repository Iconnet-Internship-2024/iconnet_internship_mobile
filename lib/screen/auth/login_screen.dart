import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconnet_internship_mobile/screen/auth/register_screen.dart';
import 'package:iconnet_internship_mobile/screen/auth/passwords/reset_password_form_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 100),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'asset/logo_pln_icon_plus.jpeg',
                        width: 150,
                        height: 150,
                      ),
                      const Positioned(
                        bottom: 0,
                        child: Text(
                          "Internship",
                          style: TextStyle(color: Colors.black, fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const InputWrapper(),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Haven't account? ",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Sign up!',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordFormPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputWrapper extends StatefulWidget {
  const InputWrapper({Key? key}) : super(key: key);

  @override
  _InputWrapperState createState() => _InputWrapperState();
}

class _InputWrapperState extends State<InputWrapper> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();
    try {
      final authResponse = await authService.login(
        _identifierController.text,
        _passwordController.text,
      );

      print('Login Response: Message: ${authResponse.message}');

      if (authResponse.isSuccess) {
        final prefs = await SharedPreferences.getInstance();
        String token = authResponse.token;

        // Decode token untuk mendapatkan roleId
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int roleId = decodedToken['roleId'];

        // Simpan roleId
        await prefs.setInt('roleId', roleId);

        if (roleId == 1) {
          Navigator.pushReplacementNamed(context, '/pelajar_dashboard');
        } else if (roleId == 2) {
          Navigator.pushReplacementNamed(context, '/mahasiswa_dashboard');
        } else {
          _showDialog('Error', 'Unknown role ID: $roleId');
        }
      } else {
        _showDialog('Login Failed', authResponse.message);
      }
    } catch (e) {
      _showDialog('Error', 'Login failed. Please check your credentials.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 80),
          _buildInputField("Username or Email", _identifierController),
          const SizedBox(height: 20),
          _buildPasswordField("Password", _passwordController),
          const SizedBox(height: 20),
          Container(
            width: 150,
            height: 40,
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
      ),
    );
  }

  Widget _buildPasswordField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
      ),
    );
  }
}
