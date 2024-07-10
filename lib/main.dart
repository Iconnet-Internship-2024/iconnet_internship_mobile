import 'package:flutter/material.dart';
// import 'package:iconnet_internship_mobile/screen/first_screen.dart';
import 'package:iconnet_internship_mobile/screen/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: FirstScreen(),
      home: HomePage(),
    );
  }
}
