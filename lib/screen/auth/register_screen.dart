import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/auth/login_screen.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
                  const LogoAndText(),
                  const SizedBox(height: 20),
                  const InputWrapper(),
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
          SizedBox(height: 80),
          _buildInputField("Username"),
          const SizedBox(height: 20),
          _buildInputField("Email"),
          const SizedBox(height: 20),
          _buildPasswordField("Password"),
          const SizedBox(height: 20),
          _buildPasswordField("Confirm Password"),
          const SizedBox(height: 30),
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
                // Add functionality for registration button here
              },
              child: const Text(
                "Register",
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

class LogoAndText extends StatelessWidget {
  const LogoAndText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Image.asset(
            'asset/logo_pln_icon_plus.jpeg',
            width: 150,
            height: 150,
          ),
        ),
        const Positioned(
          bottom: 0,
          child: Text(
            "Internship",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
      ],
    );
  }
}
