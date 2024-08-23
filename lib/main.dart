import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconnet_internship_mobile/screen/first_screen.dart';
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart';
import 'package:iconnet_internship_mobile/screen/pelajar_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          } else {
            return snapshot.data!;
          }
        },
      ),
      routes: {
        '/pelajar_dashboard': (context) => PelajarDashboard(),
        '/mahasiswa_dashboard': (context) => MahasiswaDashboard(),
      },
    );
  }

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    int? roleId = prefs.getInt('roleId');

    if (authToken == null || roleId == null) {
      return FirstScreen(); // Halaman login jika token atau roleId tidak ada
    } else if (roleId == 1) {
      return PelajarDashboard();
    } else if (roleId == 2) {
      return MahasiswaDashboard();
    } else {
      return Scaffold(body: Center(child: Text('Unknown role ID: $roleId')));
    }
  }
}
