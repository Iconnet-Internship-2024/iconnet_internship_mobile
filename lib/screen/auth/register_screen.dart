import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/auth/login_screen.dart'; // Import LoginPage

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              primaryColors,
              primaryColors.withOpacity(0.9),
              primaryColors.withOpacity(0.8),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 80),
              const RegisterHeader(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(), // Navigate to LoginPage
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Have account? ",
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: "Sign in here",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline, 
                          decorationColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 180,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: const RegisterInputWrapper(),
              ),
              Container(
                width: double.infinity,
                color: const Color(0xFF625A5A), // Warna latar belakang abu-abu
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Copyright 2024 - PLN Icon Plus",
                  style: TextStyle(
                    fontSize: 5,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center align the text
        children: const <Widget>[
          Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontSize: 40),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Sign up to start",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
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
            'asset/logo_pln_icon_plus.jpeg', // Ganti dengan path/logo yang sesuai
            width: 150, // Sesuaikan ukuran logo
            height: 150, // Sesuaikan ukuran logo
          ),
        ),
        const Positioned(
          bottom: 0,
          child: Text(
            "Internship",
            style: TextStyle(color: Colors.black, fontSize: 24), // Sesuaikan ukuran teks
          ),
        ),
      ],
    );
  }
}

class RegisterInputWrapper extends StatelessWidget {
  const RegisterInputWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          const LogoAndText(), // Include LogoAndText widget here
          const SizedBox(height: 80),
          _buildInputField("Username"),
          const SizedBox(height: 20),
          _buildInputField("Email"),
          const SizedBox(height: 20),
          _buildPasswordField("Password"),
          const SizedBox(height: 20),
          _buildPasswordField("Confirm Password"),
          const SizedBox(height: 30),
          Container(
            width: 150, // Ubah lebar sesuai kebutuhan
            height: 40, // Ubah tinggi sesuai kebutuhan
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Ubah warna latar belakang tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Tambahkan aksi yang dijalankan saat tombol ditekan
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
          const SizedBox(height: 20),
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
        border: Border.all(color: Colors.black), // Black border
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
        border: Border.all(color: Colors.black), // Black border
      ),
      child: TextField(
        obscureText: true, // Teks tersembunyi (berbentuk titik atau bintang)
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
