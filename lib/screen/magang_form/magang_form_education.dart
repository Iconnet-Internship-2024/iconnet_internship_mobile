import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart';
import 'package:iconnet_internship_mobile/screen/SK_page.dart';
import 'package:iconnet_internship_mobile/screen/profile_page.dart';
import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_personal.dart'; 
import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_submission.dart';

enum EducationLevel { D1, D2, D3, D4, S1, S2, S3 }

class MagangFormEducation extends StatefulWidget {
  @override
  _MagangFormEducationState createState() => _MagangFormEducationState();
}

class _MagangFormEducationState extends State<MagangFormEducation> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  EducationLevel? _educationLevel;

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
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Masukkan Data Anda\nDengan Benar',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDropdownField<EducationLevel>(
                'Tingkat Pendidikan',
                'Tingkat Pendidikan harus dipilih',
                EducationLevel.values.map((EducationLevel level) {
                  return DropdownMenuItem<EducationLevel>(
                    value: level,
                    child: Text(
                      level.toString().split('.').last,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                (EducationLevel? newValue) {
                  setState(() {
                    _educationLevel = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildTextField('NIM', 'NIM harus diisi', hintText: 'Isi NIM anda'),
              const SizedBox(height: 20),
              _buildTextField('Kampus', 'Kampus harus diisi', hintText: 'Isi nama kampus dengan lengkap tidak boleh disingkat'),
              const SizedBox(height: 20),
              _buildTextField('Fakultas', 'Fakultas harus diisi'),
              const SizedBox(height: 20),
              _buildTextField('Program Studi', 'Program Studi harus diisi'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      // Navigate back to the personal form
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MagangFormPersonal()),
                      );
                    },
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle form submission or navigate to the next page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MagangFormSubmission()), // Change this to your submit page
                        );
                      }
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: Navbar(
        selectedIndex: 1, // Set this to 1 for Education highlight
        onItemTapped: (index) {
          // Handle item tap
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
      ),
    );
  }

  Widget _buildTextField(String label, String validationMessage, {String hintText = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validationMessage;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>(String label, String validationMessage, List<DropdownMenuItem<T>> items, ValueChanged<T?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: items,
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return validationMessage;
            }
            return null;
          },
        ),
      ],
    );
  }
}
