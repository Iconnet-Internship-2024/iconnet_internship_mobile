import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart'; 
import 'package:iconnet_internship_mobile/screen/SK_page.dart'; 
import 'package:iconnet_internship_mobile/screen/profile_page.dart';

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
        color: primaryColors,
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'PLN Icon Plus Internship',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 2,
                    color: Colors.white,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildNavItem(
                    icon: Icons.home,
                    text: 'Beranda',
                    index: 0,
                    context: context,
                  ),
                  _buildNavItem(
                    icon: Icons.question_answer,
                    text: 'Syarat & Ketentuan',
                    index: 1,
                    context: context,
                  ),
                  _buildNavItem(
                    icon: Icons.person,
                    text: 'Profile',
                    index: 2,
                    context: context,
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
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        widget.onItemTapped(index);
        Navigator.pop(context); // Close the drawer

        // Navigate to the corresponding page
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SKPage()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        }
      },
      child: Container(
        color: widget.selectedIndex == index ? Colors.white24 : Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            text,
            style: TextStyle(
              color: widget.selectedIndex == index ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
