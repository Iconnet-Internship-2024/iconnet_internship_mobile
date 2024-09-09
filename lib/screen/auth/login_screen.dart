import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconnet_internship_mobile/screen/auth/register_screen.dart';
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
                          text: "Don't have an account? ",
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
  String? _identifierError;
  String? _passwordError;

  void _login() async {
    setState(() {
      _identifierError = null;
      _passwordError = null;
    });

    final identifier = _identifierController.text;
    final password = _passwordController.text;

    if (identifier.isEmpty) {
      setState(() {
        _identifierError = 'Email atau Username harus diisi!';
      });
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password harus diisi!';
      });
    }

    // If there are any errors, stop further processing
    if (_identifierError != null || _passwordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();
    try {
      final authResponse = await authService.login(identifier, password);

      if (authResponse.isSuccess) {
        final prefs = await SharedPreferences.getInstance();
        String token = authResponse.token;

        // Save token
        await prefs.setString('authToken', token);

        print('Token saved: $token');

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int roleId = decodedToken['roleId'];

        print('Decoded token: $decodedToken');

        // Save roleId
        await prefs.setInt('roleId', roleId);

        // Redirect based on roleId
        if (roleId == 2) {
          Navigator.pushReplacementNamed(context, '/mahasiswa_dashboard');
        } else if (roleId == 1) {
          Navigator.pushReplacementNamed(context, '/pelajar_dashboard');
        } else {
          _showDialog('Error', 'Unknown role ID: $roleId');
        }
      } else {
        _showDialog('Login Gagal', authResponse.message);
      }
    } catch (e) {
      _showDialog('Error', 'Email, Username, atau Password Salah!. Tolong Masukkan dengan Benar!.');
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
          _buildInputField("Username atau Email", _identifierController, _identifierError),
          const SizedBox(height: 20),
          _buildPasswordField("Password", _passwordController, _passwordError),
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
                  ? const CircularProgressIndicator(color: Colors.white)
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

  Widget _buildInputField(String label, TextEditingController controller, String? errorText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorText: errorText,
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, String? errorText) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorText: errorText,
      ),
    );
  }
}
