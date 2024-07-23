import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/home_page.dart'; 
import 'package:iconnet_internship_mobile/screen/SK_page.dart'; 

class Navbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Navbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: primaryColors, // Warna latar belakang drawer sesuai primaryColors
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'PLN Icon Plus Internship', // Judul navbar
                style: TextStyle(
                  color: Colors.white, // Warna teks putih
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildNavItem(
                    icon: Icons.home,
                    text: 'Beranda',
                    index: 0,
                    context: context, // Pass the context
                  ),
                  _buildNavItem(
                    icon: Icons.question_answer,
                    text: 'Syarat & Ketentuan',
                    index: 1,
                    context: context, // Pass the context
                  ),
                  _buildNavItem(
                    icon: Icons.person,
                    text: 'Profile',
                    index: 2,
                    context: context, // Pass the context
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String text,
    required int index,
    required BuildContext context, // Add context parameter
  }) {
    return InkWell(
      onTap: () {
        widget.onItemTapped(index);
        Navigator.pop(context);

        // Navigate to the corresponding page
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (index == 1) {
          // Navigate to FAQ page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SKPage()), // Ganti dengan halaman FAQ Anda
          );
        } else if (index == 2) {
          // Navigate to Profile page
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ProfilePage()), // Ganti dengan halaman Profile Anda
          // );
        }
      },
      onHover: (isHovering) {
        setState(() {
          // Set the hover state for this item
        });
      },
      child: Container(
        color: widget.selectedIndex == index ? Colors.white24 : Colors.transparent, // Warna saat item terpilih
        child: ListTile(
          leading: Icon(icon, color: Colors.white), // Icon berwarna putih
          title: Text(text, style: TextStyle(color: Colors.white)), // Teks berwarna putih
          selected: widget.selectedIndex == index,
          selectedTileColor: Colors.white24, // Warna saat item terpilih
          hoverColor: Colors.white24, // Warna saat item di-hover
        ),
      ),
    );
  }
}
