import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/screen/first_screen.dart';
// import 'package:iconnet_internship_mobile/screen/pelajar_dashboard.dart';
// import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart';
// import 'package:iconnet_internship_mobile/screen/auth/passwords/reset_password_form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
      // home: PelajarDashboard(),
      // home: MahasiswaDashboard(),
      // home: ResetPasswordFormPage(),
    );
  }
}
