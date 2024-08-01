import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart';

class SKPage extends StatefulWidget {
  const SKPage({Key? key}) : super(key: key);

  @override
  State<SKPage> createState() => _SKPageState();
}

class _SKPageState extends State<SKPage> {
  int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SKPage()),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); 
      return false; 
    }
    return true; 
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alur Pendaftaran Program Internship!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    '1. Lakukan Registrasi jika anda belum memiliki akun\n'
                    '2. Kemudian lakukan login jika anda sudah memiliki akun\n'
                    '3. Selanjutnya anda dapat mengisi data diri dengan lengkap pada halaman profile. Harap data diri diisi dengan lengkap dan benar agar bisa melakukan tahap selanjutnya, yaitu pengajuan pendaftaran internship\n'
                    '4. Lakukan pengajuan pendaftaran internship dengan memilih kategori yang sudah ditentukan, yaitu : mahasiswa ataupun siswa. Kemudian isi semua formulir dengan lengkap dan benar.\n'
                    '5. Setelah anda mengisi data diri dan form pengajuan internship, maka anda harus menunggu proses pengajuan dan anda akan mendapatkan status balasan maksimal 14 hari setelah pengajuan dilakukan.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Divider(color: Colors.grey, height: 40, thickness: 2),
                const Text(
                  'Syarat dan Ketentuan Pendaftaran Program Internship!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    '1. xxxxxxx\n'
                    '2. xxxxxxx\n'
                    '3. xxxxxxx\n'
                    '4. xxxxxxx\n'
                    '5. xxxxxxx\n'
                    '6. xxxxxxx\n'
                    '7. xxxxxxx\n',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Divider(color: Colors.grey, height: 40, thickness: 2),
                const Text(
                  'Frequently Asked Question!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    '1. xxxxxxx\n'
                    '2. xxxxxxx\n'
                    '3. xxxxxxx\n'
                    '4. xxxxxxx\n'
                    '5. xxxxxxx\n'
                    '6. xxxxxxx\n'
                    '7. xxxxxxx\n',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: Navbar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
