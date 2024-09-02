import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:iconnet_internship_mobile/utils/colors.dart';
import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
import 'package:iconnet_internship_mobile/screen/pelajar_dashboard.dart';
import 'package:iconnet_internship_mobile/screen/pkl_form/pkl_form_submission/magang_details_submission.dart';
import 'package:iconnet_internship_mobile/screen/SK_page.dart';
import 'package:iconnet_internship_mobile/screen/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubmissionFormScreen extends StatefulWidget {
  @override
  _SubmissionFormScreenState createState() => _SubmissionFormScreenState();
}

class _SubmissionFormScreenState extends State<SubmissionFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  int? _selectedJobDivisionId;
  List<Map<String, dynamic>> _jobDivisions = [];
  DateTime? _startDate;
  DateTime? _endDate;
  PlatformFile? _coverLetter;
  PlatformFile? _proposal;

  // Set default program_id
  final int _programId = 1;

  // Mapping of job division IDs to names
  final Map<int, String> _jobDivisionNames = {
    1: 'Default',
    2: 'Engineering',
    3: 'Marketing',
    4: 'Human Resources',
    5: 'Sales',
  };

  @override
  void initState() {
    super.initState();
    _jobDivisions = _jobDivisionNames.entries.map((entry) {
      return {'id': entry.key, 'name': entry.value};
    }).toList();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
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

  Future<void> _pickFile(bool isCoverLetter) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        if (isCoverLetter) {
          _coverLetter = result.files.first;
        } else {
          _proposal = result.files.first;
        }
      });
    }
  }
  
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_coverLetter == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Surat Pengantar harus diunggah.')),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak ditemukan. Mohon login terlebih dahulu.')),
        );
        return;
      }

      // Show confirmation dialog
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

      if (confirm == true) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:3000/submission/add/im'),
        );

        request.headers['Authorization'] = 'Bearer $token';

        // Add files to the request
        if (_coverLetter != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'cover_letter',
            _coverLetter!.bytes!,
            filename: _coverLetter!.name,
          ));
        }

        if (_proposal != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'proposal',
            _proposal!.bytes!,
            filename: _proposal!.name,
          ));
        }

        // Add form fields to the request
        request.fields['job_division_id'] = _selectedJobDivisionId?.toString() ?? '';
        request.fields['program_id'] = _programId.toString();
        request.fields['start_date'] = _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : '';
        request.fields['end_date'] = _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '';

        print('Request fields: ${request.fields}');
        print('Request files: ${request.files}');

        var response = await request.send();
        if (response.statusCode == 200) {
          // Show success notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Berhasil Submit: ${response.reasonPhrase}')),
          );

          // Navigate to the details submission page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SubmissionDetailsScreen()), 
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
          MaterialPageRoute(builder: (context) => PelajarDashboard()),
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
              _buildDropdownField(
                'Divisi',
                'Divisi harus dipilih',
                _jobDivisions.map((division) {
                  return DropdownMenuItem<int>(
                    value: division['id'],
                    child: Text(division['name']),
                  );
                }).toList(),
                (int? newValue) {
                  setState(() {
                    _selectedJobDivisionId = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildDateField('Tanggal Mulai', _startDate, () => _selectDate(context, true)),
              const SizedBox(height: 20),
              _buildDateField('Tanggal Akhir', _endDate, () => _selectDate(context, false)),
              const SizedBox(height: 20),
              _buildFilePicker('Surat Pengantar', _coverLetter, () => _pickFile(true)),
              const SizedBox(height: 20),
              _buildFilePicker('Proposal (Opsional)', _proposal, () => _pickFile(false)),
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

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            ),
            child: Text(
              date != null ? DateFormat('yyyy-MM-dd').format(date) : 'Pilih tanggal',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker(String label, PlatformFile? file, VoidCallback onPickFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        InkWell(
          onTap: onPickFile,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.attach_file),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            ),
            child: Text(
              file != null ? file.name : 'Belum ada file yang dipilih',
              style: TextStyle(fontSize: 16),
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
        SizedBox(height: 8),
        DropdownButtonFormField<T>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          validator: (value) => value == null ? validationMessage : null,
          items: items,
          onChanged: onChanged,
          style: TextStyle(color: Colors.black87, fontSize: 16),
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.black87),
          iconSize: 24,
        ),
      ],
    );
  }
}
