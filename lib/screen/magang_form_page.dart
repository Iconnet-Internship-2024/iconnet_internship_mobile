import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:iconnet_internship_mobile/screen/home_page.dart'; 
import 'package:iconnet_internship_mobile/screen/faq_page.dart'; 

enum Divisi {
  administrasi,
  teknisi,
}

class MagangFormPage extends StatefulWidget {
  const MagangFormPage({Key? key}) : super(key: key);

  @override
  State<MagangFormPage> createState() => _MagangFormPageState();
}

class _MagangFormPageState extends State<MagangFormPage> {
  int _selectedIndex = -1; // Dalam halaman ini, index navbar tidak dipilih
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FAQPage()),
      );
    }
    // Add navigation for other pages if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColors,
        title: const Text(
          'PLN Icon Plus Internship',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('asset/home1.png'), // Ganti dengan gambar lingkaran
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Username', // Ganti dengan nama pengguna
                    style: TextStyle(color: primaryColors, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Email', // Ganti dengan alamat email
                    style: TextStyle(color: primaryColors),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey), // Garis pemisah
                  SizedBox(height: 20),
                  Column(
                    children: [
                      _buildInfoItem(icon: Icons.account_circle, label: 'Divisi', additionalText: 'Teknisi'),
                      SizedBox(height: 10),
                      _buildDivider(),
                      _buildInfoItem(icon: Icons.calendar_today, label: 'Tanggal Mulai', additionalText: '21 April 2020'),
                      SizedBox(height: 10),
                      _buildDivider(),
                      _buildInfoItem(icon: Icons.calendar_today, label: 'Tanggal Selesai', additionalText: '30 April 2020'),
                      SizedBox(height: 10),
                      _buildDivider(),
                      _buildInfoItem(icon: Icons.file_copy, label: 'Surat Pengantar', additionalText: 'nama_file.pdf'),
                      SizedBox(height: 10),
                      _buildDivider(),
                      _buildInfoItem(icon: Icons.file_copy, label: 'Transkrip Nilai', additionalText: 'nama_file.pdf'),
                      SizedBox(height: 10),
                      _buildDivider(),
                      _buildInfoItem(icon: Icons.file_copy, label: 'Proposal', additionalText: 'nama_file.pdf'),
                      SizedBox(height: 10),
                      _buildDivider(),
                      _buildInfoItem(icon: Icons.notifications, label: 'Status', additionalText: 'Pending'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey), // Garis pemisah
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label, required String additionalText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: primaryColors, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$label : ',
                style: TextStyle(color: primaryColors, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: additionalText,
                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(color: Colors.grey),
    );
  }
}
