import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart'; 
import 'package:iconnet_internship_mobile/screen/pelajar_dashboard.dart'; 
import 'package:iconnet_internship_mobile/screen/SK_page.dart'; 
import 'package:iconnet_internship_mobile/screen/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              padding: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'PLN Icon Plus Internship',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            _buildDrawerItem(context, Icons.dashboard, "Dashboard", 0),
            _buildDrawerItem(context, Icons.note, "SK", 1),
            _buildDrawerItem(context, Icons.person, "Profile", 2),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int index) {
    return InkWell(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        int? roleId = prefs.getInt('roleId');

        if (index == 0) {
          if (roleId == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PelajarDashboard()),
            );
          } else if (roleId == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
            );
          }
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
        padding: const EdgeInsets.all(10),
        decoration: widget.selectedIndex == index
            ? const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              color: widget.selectedIndex == index ? primaryColors : Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: widget.selectedIndex == index ? primaryColors : Colors.white,
                fontWeight: widget.selectedIndex == index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
