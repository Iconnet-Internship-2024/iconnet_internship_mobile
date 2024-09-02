import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:iconnet_internship_mobile/screen/mahasiswa_dashboard.dart'; 
import 'package:iconnet_internship_mobile/screen/SK_page.dart'; 
import 'package:iconnet_internship_mobile/screen/profile_page.dart'; 
import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_submission.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum Gender { male, female }
enum Religion { islam, kristen, katolik, hindu, buddha, konghucu, lainnya }
enum EducationDegree { D1, D2, D3, D4, S1, S2, S3 }

class ApplicantFormScreen extends StatefulWidget {
  @override
  _ApplicantFormScreenState createState() => _ApplicantFormScreenState();
}

class _ApplicantFormScreenState extends State<ApplicantFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  DateTime? _birthDate;
  Gender? _gender;
  Religion? _religion;
  EducationDegree? _educationDegree;
  String? _name;
  String? _placeOfBirth;
  String? _phoneNumber;
  String? _city;
  String? _address;
  String? _studentId;
  String? _educationInstitution;
  String? _educationMajor;
  String? _educationFaculty;
  PlatformFile? _photo;
  PlatformFile? _educationTranscript;

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

  // Function to pick files (photo or transcript)
  Future<void> _pickFile(bool isPhoto) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: isPhoto ? ['jpg', 'jpeg'] : ['pdf'],
    );

    if (result != null) {
      setState(() {
        if (isPhoto) {
          _photo = result.files.first;
        } else {
          _educationTranscript = result.files.first;
        }
      });
    }
  }

  // Function to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak ditemukan. Mohon login terlebih dahulu.')),
        );
        return;
      }

      // Menampilkan dialog konfirmasi
      bool? confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Konfirmasi', style: TextStyle(color: Colors.black)),
            content: Text('Apakah Anda yakin ingin mengirim data ini? Data yang dikirim tidak dapat diubah lagi.', style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Tidak', style: TextStyle(color: primaryColors)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Ya', style: TextStyle(color: primaryColors)),
              ),
            ],
          );
        },
      );

      // Jika pengguna menekan 'Ya', lanjutkan dengan pengiriman form
      if (confirm == true) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:3000/applicant'),
          // Uri.parse('http://10.0.2.2:3000/applicant'),
        );

        // Set authorization header
        request.headers['Authorization'] = 'Bearer $token';

        // Add files to the request
        if (_photo != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'photo',
            _photo!.bytes!,
            filename: _photo!.name,
          ));
        }

        if (_educationTranscript != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'education_transcript',
            _educationTranscript!.bytes!,
            filename: _educationTranscript!.name,
          ));
        }

        // Add form fields to the request
        request.fields['name'] = _name ?? '';
        request.fields['place_of_birth'] = _placeOfBirth ?? '';
        request.fields['date_of_birth'] = _birthDate != null ? DateFormat('yyyy-MM-dd').format(_birthDate!) : '';
        request.fields['gender'] = _gender != null ? _gender.toString().split('.').last : '';
        request.fields['phone_number'] = _phoneNumber ?? '';
        request.fields['city'] = _city ?? '';
        request.fields['address'] = _address ?? '';
        request.fields['religion'] = _religion != null ? _religion.toString().split('.').last : '';
        request.fields['education_degree'] = _educationDegree != null ? _educationDegree.toString().split('.').last : '';
        request.fields['student_id'] = _studentId ?? '';
        request.fields['education_institution'] = _educationInstitution ?? '';
        request.fields['education_major'] = _educationMajor ?? '';
        request.fields['education_faculty'] = _educationFaculty ?? '';

        // Send the request
        var response = await request.send();
        print('Response status: ${response.statusCode}');
        print('Response reason: ${response.reasonPhrase}');

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MagangFormSubmission()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim data: ${response.reasonPhrase}')),
          );
        }
      }
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
      ),
      drawer: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nama Lengkap', 'Nama harus diisi', (value) => _name = value),
              const SizedBox(height: 20),
              _buildTextField('Kota Kelahiran', 'Kota Kelahiran harus diisi', (value) => _placeOfBirth = value),
              const SizedBox(height: 20),
              _buildDateField(),
              const SizedBox(height: 20),
              _buildDropdownField<Gender>(
                'Jenis Kelamin',
                'Jenis Kelamin harus dipilih',
                Gender.values.map((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(gender == Gender.male ? 'Laki-laki' : 'Perempuan'),
                  );
                }).toList(),
                (Gender? newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildTextField('No. HP', 'No. HP harus diisi', (value) => _phoneNumber = value),
              const SizedBox(height: 20),
              _buildTextField('Domisili', 'Domisili harus diisi', (value) => _city = value),
              const SizedBox(height: 20),
              _buildTextField('Alamat KTP', 'Alamat KTP harus diisi', (value) => _address = value),
              const SizedBox(height: 20),
              _buildDropdownField<Religion>(
                'Agama',
                'Agama harus dipilih',
                Religion.values.map((Religion religion) {
                  return DropdownMenuItem<Religion>(
                    value: religion,
                    child: Text(religion.toString().split('.').last),
                  );
                }).toList(),
                (Religion? newValue) {
                  setState(() {
                    _religion = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildDropdownField<EducationDegree>(
                'Jenjang Pendidikan',
                'Jenjang Pendidikan harus dipilih',
                EducationDegree.values.map((EducationDegree degree) {
                  return DropdownMenuItem<EducationDegree>(
                    value: degree,
                    child: Text(degree.toString().split('.').last),
                  );
                }).toList(),
                (EducationDegree? newValue) {
                  setState(() {
                    _educationDegree = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildTextField('NIM', 'NIM harus diisi', (value) => _studentId = value),
              const SizedBox(height: 20),
              _buildTextField('Asal Universitas', 'Asal Universitas harus diisi', (value) => _educationInstitution = value),
              const SizedBox(height: 20),
              _buildTextField('Jurusan', 'Jurusan harus diisi', (value) => _educationMajor = value),
              const SizedBox(height: 20),
              _buildTextField('Fakultas', 'Fakultas harus diisi', (value) => _educationFaculty = value),
              const SizedBox(height: 20),
              _buildFilePicker('Upload Foto', _photo, () => _pickFile(true)),
              const SizedBox(height: 20),
              _buildFilePicker('Upload Transkrip Nilai', _educationTranscript, () => _pickFile(false)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), 
                        ),
                      ),
                      child: Text('Submit', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String validationMessage, Function(String?) onSave) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Masukkan $label',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value == null || value.isEmpty ? validationMessage : null,
          onSaved: onSave,
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tanggal Lahir',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8), // Add spacing between label and field
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12), // Match padding of other fields
            ),
            child: Text(
              _birthDate != null ? DateFormat('yyyy-MM-dd').format(_birthDate!) : 'Pilih Tanggal',
              style: TextStyle(fontSize: 16), // Match font size with other fields
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>(
    String label,
    String validationMessage,
    List<DropdownMenuItem<T>> items,
    Function(T?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8), // Add spacing between label and dropdown
        DropdownButtonFormField<T>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white, // Background color of dropdown
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          validator: (value) => value == null ? validationMessage : null,
          items: items,
          onChanged: onChanged,
          style: TextStyle(color: Colors.black87, fontSize: 16), // Dropdown text style
          dropdownColor: Colors.white, // Dropdown menu background color
          icon: Icon(Icons.arrow_drop_down, color: Colors.black87), // Dropdown icon color
          iconSize: 24, // Size of dropdown icon
        ),
      ],
    );
  }

  Widget _buildFilePicker(String label, PlatformFile? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8), // Add spacing between label and picker
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Icon(
                  file != null ? Icons.attach_file : Icons.upload_file,
                  color: Colors.black87,
                ),
                SizedBox(width: 10), // Add spacing between icon and text
                Expanded(
                  child: Text(
                    file != null ? file.name : 'Pilih File',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
