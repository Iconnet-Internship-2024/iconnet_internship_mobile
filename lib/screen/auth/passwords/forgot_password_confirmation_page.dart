import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/auth/passwords/forgot_password_email_page.dart'; 

class ForgotPasswordConfirmationPage extends StatelessWidget {
  final String email;

  ForgotPasswordConfirmationPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(), // Spacer untuk memberikan ruang di atas
              Icon(
                Icons.email,
                size: 100,
                color: primaryColors,
              ),
              SizedBox(height: 20),
              Text(
                'Email Terkirim',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColors,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Kami telah mengirimkan email ke ($email). Periksa kotak masuk Anda dan ikuti instruksi untuk mengatur ulang kata sandi akun Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Tambahkan fungsi untuk mengirim ulang email di sini
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Tidak menerima email? ",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Kirim ulang email!',
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
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordEmailPage(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Alamat email salah? ",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Ubah alamat email',
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
              Spacer(), // Spacer untuk memberikan ruang di bawah
            ],
          ),
        ),
      ),
    );
  }
}
