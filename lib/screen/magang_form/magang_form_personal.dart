import 'package:flutter/material.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart';
import 'package:iconnet_internship_mobile/screen/SK_page.dart';
import 'package:iconnet_internship_mobile/screen/profile_page.dart';
import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_education.dart';
import 'package:intl/intl.dart';

enum Gender { male, female }
enum Religion { islam, christian, hindu, buddha, other }

class MagangFormPersonal extends StatefulWidget {
  @override
  _MagangFormPersonalState createState() => _MagangFormPersonalState();
}

class _MagangFormPersonalState extends State<MagangFormPersonal> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _birthDate;
  Gender? _gender;
  Religion? _religion;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColors,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            primaryColor: primaryColors,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
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
              _buildTextField('Nama Lengkap', 'Nama harus diisi', hintText: 'Masukkan Nama Lengkap Anda'),
              const SizedBox(height: 20),
              _buildTextField('Kota Kelahiran', 'Kota Kelahiran harus diisi', hintText: 'Ex: Balikpapan'),
              const SizedBox(height: 20),
              _buildDateField(),
              const SizedBox(height: 20),
              _buildDropdownField<Gender>('Jenis Kelamin', 'Jenis Kelamin harus dipilih', Gender.values.map((Gender gender) {
                return DropdownMenuItem<Gender>(
                  value: gender,
                  child: Text(
                    gender == Gender.male ? 'Laki-laki' : 'Perempuan',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(), (Gender? newValue) {
                setState(() {
                  _gender = newValue;
                });
              }),
              const SizedBox(height: 20),
              _buildTextField('No. HP', 'No. HP harus diisi', hintText: 'Masukkan No. HP Anda dengan benar'),
              const SizedBox(height: 20),
              _buildTextField('Domisili', 'Domisili harus diisi', hintText: 'Domisili Anda sekarang'),
              const SizedBox(height: 20),
              _buildTextField('Alamat KTP', 'Alamat KTP harus diisi'),
              const SizedBox(height: 20),
              _buildDropdownField<Religion>('Agama', 'Agama harus dipilih', Religion.values.map((Religion religion) {
                return DropdownMenuItem<Religion>(
                  value: religion,
                  child: Text(
                    religion == Religion.islam ? 'Islam' :
                    religion == Religion.christian ? 'Kristen' :
                    religion == Religion.hindu ? 'Hindu' :
                    religion == Religion.buddha ? 'Budha' : 'Lainnya',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(), (Religion? newValue) {
                setState(() {
                  _religion = newValue;
                });
              }),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MagangFormEducation()),
                      );
                    }
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Navbar(
        selectedIndex: 0, // Set this to 0 for Dashboard highlight
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

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tanggal Lahir', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Pilih Tanggal Lahir',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              onPressed: () => _selectDate(context),
            ),
          ),
          controller: TextEditingController(text: _birthDate == null ? '' : DateFormat('dd/MM/yyyy').format(_birthDate!)),
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
