import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart'; // Import your color utilities
import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_education.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart'; // Import the navigation bar
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart'; 
import 'package:iconnet_internship_mobile/screen/SK_page.dart'; 
import 'package:iconnet_internship_mobile/screen/profile_page.dart'; 

enum Divisi {
  administrasi,
  teknisi,
}

class MagangFormSubmission extends StatefulWidget {
  @override
  _MagangFormSubmissionState createState() => _MagangFormSubmissionState();
}

class _MagangFormSubmissionState extends State<MagangFormSubmission> {
  Divisi? _selectedDivisi;
  DateTime? _startDate;
  DateTime? _endDate;
  PlatformFile? _suratPengantar;
  PlatformFile? _transkripNilai;
  PlatformFile? _proposal;
  PlatformFile? _foto;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0; // Default selected index

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColors, // Use primary color
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickFile(bool isImage, Function(PlatformFile) onFilePicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: isImage ? ['jpg', 'jpeg'] : ['pdf'],
    );

    if (result != null) {
      setState(() {
        onFilePicked(result.files.first);
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Anda yakin mau mengirimkan formulir ini? Data tidak dapat diubah setelah pengiriman.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Handle form submission
                },
                child: Text('Kirim'),
              ),
            ],
          );
        },
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on selected index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SKPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColors, // Use primary color
        title: const Text(
          'Magang/KP Registration',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Masukkan Data Anda\nDengan Benar',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Divisi>(
                decoration: InputDecoration(
                  labelText: 'Divisi',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColors, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: _selectedDivisi,
                items: Divisi.values.map((Divisi divisi) {
                  return DropdownMenuItem<Divisi>(
                    value: divisi,
                    child: Text(
                      divisi == Divisi.administrasi ? 'Administrasi' : 'Teknisi',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (Divisi? newValue) {
                  setState(() {
                    _selectedDivisi = newValue;
                  });
                },
                validator: (value) => value == null ? 'Divisi harus dipilih' : null,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Mulai',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColors, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                    onPressed: () => _selectDate(context, true),
                  ),
                ),
                controller: TextEditingController(
                  text: _startDate == null ? '' : DateFormat('dd/MM/yyyy').format(_startDate!),
                ),
                validator: (value) => value!.isEmpty ? 'Tanggal Mulai harus dipilih' : null,
                cursorColor: primaryColors,
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Selesai',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColors, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                    onPressed: () => _selectDate(context, false),
                  ),
                ),
                controller: TextEditingController(
                  text: _endDate == null ? '' : DateFormat('dd/MM/yyyy').format(_endDate!),
                ),
                validator: (value) => value!.isEmpty ? 'Tanggal Selesai harus dipilih' : null,
                cursorColor: primaryColors,
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Surat Pengantar (PDF)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColors, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.black),
                    onPressed: () => _pickFile(false, (file) => _suratPengantar = file),
                  ),
                ),
                controller: TextEditingController(
                  text: _suratPengantar == null ? '' : _suratPengantar!.name,
                ),
                validator: (value) => value!.isEmpty ? 'Surat Pengantar harus diunggah' : null,
                cursorColor: primaryColors,
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Transkrip Nilai (PDF)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColors, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.black),
                    onPressed: () => _pickFile(false, (file) => _transkripNilai = file),
                  ),
                ),
                controller: TextEditingController(
                  text: _transkripNilai == null ? '' : _transkripNilai!.name,
                ),
                cursorColor: primaryColors,
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Proposal (PDF, optional)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColors, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.black),
                    onPressed: () => _pickFile(false, (file) => _proposal = file),
                  ),
                ),
                controller: TextEditingController(
                  text: _proposal == null ? '' : _proposal!.name,
                ),
                cursorColor: primaryColors,
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Foto (JPG/JPEG)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColors, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.black),
                    onPressed: () => _pickFile(true, (file) => _foto = file),
                  ),
                ),
                controller: TextEditingController(
                  text: _foto == null ? '' : _foto!.name,
                ),
                cursorColor: primaryColors,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MagangFormEducation()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Gray background color
                      foregroundColor: Colors.black, // Black text color
                    ),
                    child: const Text('Kembali'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Black background color
                      foregroundColor: Colors.white, // White text color
                    ),
                    child: const Text('Kirim'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
