import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/screen/auth/login_screen.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColors,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(
                  "asset/home2.jpeg",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 200,
                    color: Colors.red.withOpacity(0.5), 
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          "Selamat Datang di Program Internship \nPLN ICON PLUS \nSBU Regional Kalimantan",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 0),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    "asset/home1.png",
                    height: 100,
                    width: 80,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "PT Indonesia Comnets Plus, anak usaha PLN yang bergerak di bidang teknologi informasi dan komunikasi, memiliki 26 kantor perwakilan yang tersebar di seantero Indonesia hingga akhir tahun 2021. Untuk mendukung kegiatan bisnisnya dan memberikan kesempatan bagi generasi muda, PLN Icon Plus membuka pendaftaran kerja praktik/magang untuk mahasiswa dan pelajar. Program ini menawarkan pengalaman berharga di industri teknologi informasi dan komunikasi, membantu peserta mengembangkan keterampilan dan pengetahuan mereka di bidang ini.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Apa Yang Akan Kamu Dapatkan?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(98, 90, 90, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCard(
                              context: context,
                              icon: Icons.check_circle_outline,
                              title: "Program Certificate",
                              description: "Mendapatkan sertifikat FHCI BUMN sebagai apresiasi atas kontribusi yang telah diberikan.",
                            ),
                            _buildCard(
                              context: context,
                              icon: Icons.work,
                              title: "Real Project Challenge",
                              description: "Terjun langsung dalam use case nyata pada berbagai disiplin ilmu.",
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCard(
                              context: context,
                              icon: Icons.public,
                              title: "Experience in National \n& Worldwide Company",
                              description: "Pengalaman internship di perusahaan terkemuka, sebagai gerbang karir.",
                            ),
                            _buildCard(
                              context: context,
                              icon: Icons.apartment,
                              title: "Corporate Culture",
                              description: "Budaya kerja di perusahaan digital telekomunikasi dengan core value Solid, Speed, Smart.",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: primaryColors,
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "Ayo Bergabung Di Program Kami!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 100,
                    height: 40,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFF625A5A), 
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
    );
  }

Widget _buildCard({required BuildContext context, required IconData icon, required String title, required String description}) {
  return SizedBox(
    height: 165,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xFFCB1919)), 
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity, 
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 30, color: Color(0xFFCB1919)), 
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCB1919), 
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
