import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/screen/auth/register_screen.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';

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
                      child: const Text(
                        "Haven't account? Sign up!",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Container(
            color: primaryColors,
            height: 50,
          ),
        ],
      ),
    );
  }
}

class InputWrapper extends StatelessWidget {
  const InputWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 80), // Adjusted size to match the layout
          _buildInputField("Email"),
          const SizedBox(height: 20),
          _buildPasswordField("Password"),
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
              onPressed: () {
                // Add functionality for login button here
              },
              child: const Text(
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

  Widget _buildInputField(String hint) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(225, 95, 27, .3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(225, 95, 27, .3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
