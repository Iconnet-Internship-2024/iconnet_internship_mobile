// import 'package:flutter/material.dart';
// import 'package:iconnet_internship_mobile/utils/colors.dart';
// import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
// import 'package:iconnet_internship_mobile/screen/home_page.dart';
// import 'package:iconnet_internship_mobile/screen/SK_page.dart';
// import 'package:intl/intl.dart'; 
// import 'package:file_picker/file_picker.dart'; 

// enum Divisi { administrasi, teknisi }

// class MagangFormPage extends StatefulWidget {
//   const MagangFormPage({Key? key}) : super(key: key);

//   @override
//   State<MagangFormPage> createState() => _MagangFormPageState();
// }

// class _MagangFormPageState extends State<MagangFormPage> {
//   int _selectedIndex = -1; 
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   Divisi? _selectedDivisi;
//   DateTime? _startDate;
//   DateTime? _endDate;
//   PlatformFile? _suratPengantar;
//   PlatformFile? _transkripNilai;
//   PlatformFile? _proposal;
//   PlatformFile? _foto;

//   final _formKey = GlobalKey<FormState>();

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     if (index == 0) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage()),
//       );
//     } else if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SKPage()),
//       );
//     }
//   }

//   Future<void> _selectDate(BuildContext context, bool isStartDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(
//               primary: primaryColors, 
//               onPrimary: Colors.white, 
//               onSurface: Colors.black, 
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStartDate) {
//           _startDate = picked;
//         } else {
//           _endDate = picked;
//         }
//       });
//     }
//   }

//   Future<void> _pickFile(bool isImage, Function(PlatformFile) onFilePicked) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: isImage ? ['jpg', 'jpeg'] : ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         onFilePicked(result.files.first);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: primaryColors,
//         title: const Text(
//           'PLN Icon Plus Internship',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//           color: Colors.white,
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Masukkan Data Anda\nDengan Benar',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 DropdownButtonFormField<Divisi>(
//                   decoration: InputDecoration(
//                     labelText: 'Divisi',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: primaryColors, width: 2),
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                   value: _selectedDivisi,
//                   items: Divisi.values.map((Divisi divisi) {
//                     return DropdownMenuItem<Divisi>(
//                       value: divisi,
//                       child: Text(
//                         divisi == Divisi.administrasi ? 'Administrasi' : 'Teknisi',
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (Divisi? newValue) {
//                     setState(() {
//                       _selectedDivisi = newValue;
//                     });
//                   },
//                   validator: (value) => value == null ? 'Divisi harus dipilih' : null,
//                   dropdownColor: Colors.white,
//                   style: const TextStyle(color: Colors.black),
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'Tanggal Mulai',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: primaryColors, width: 2),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.calendar_today, color: Colors.black),
//                       onPressed: () => _selectDate(context, true),
//                     ),
//                   ),
//                   controller: TextEditingController(
//                     text: _startDate == null ? '' : DateFormat('dd/MM/yyyy').format(_startDate!),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Tanggal Mulai harus dipilih' : null,
//                   cursorColor: primaryColors,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'Tanggal Selesai',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: primaryColors, width: 2),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.calendar_today, color: Colors.black),
//                       onPressed: () => _selectDate(context, false),
//                     ),
//                   ),
//                   controller: TextEditingController(
//                     text: _endDate == null ? '' : DateFormat('dd/MM/yyyy').format(_endDate!),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Tanggal Selesai harus dipilih' : null,
//                   cursorColor: primaryColors,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'Surat Pengantar (PDF)',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: primaryColors, width: 2),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.attach_file, color: Colors.black),
//                       onPressed: () => _pickFile(false, (file) => _suratPengantar = file),
//                     ),
//                   ),
//                   controller: TextEditingController(
//                     text: _suratPengantar == null ? '' : _suratPengantar!.name,
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Surat Pengantar harus diunggah' : null,
//                   cursorColor: primaryColors,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'Transkrip Nilai (PDF)',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: primaryColors, width: 2),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.attach_file, color: Colors.black),
//                       onPressed: () => _pickFile(false, (file) => _transkripNilai = file),
//                     ),
//                   ),
//                   controller: TextEditingController(
//                     text: _transkripNilai == null ? '' : _transkripNilai!.name,
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Transkrip Nilai harus diunggah' : null,
//                   cursorColor: primaryColors,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'Proposal (PDF)',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: primaryColors, width: 2),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.attach_file, color: Colors.black),
//                       onPressed: () => _pickFile(false, (file) => _proposal = file),
//                     ),
//                   ),
//                   controller: TextEditingController(
//                     text: _proposal == null ? '' : _proposal!.name,
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Proposal harus diunggah' : null,
//                   cursorColor: primaryColors,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'Foto (JPG)',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: primaryColors, width: 2),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.attach_file, color: Colors.black),
//                       onPressed: () => _pickFile(true, (file) => _foto = file),
//                     ),
//                   ),
//                   controller: TextEditingController(
//                     text: _foto == null ? '' : _foto!.name,
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Foto harus diunggah' : null,
//                   cursorColor: primaryColors,
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   width: double.infinity,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _formKey.currentState!.save();
//                         // Perform the form submission here
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     child: const Text('Submit'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       drawer: Navbar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_personal.dart';
// import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_education.dart';
// import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_submission.dart';

// class MagangFormPage extends StatefulWidget {
//   @override
//   _MagangFormPageState createState() => _MagangFormPageState();
// }

// class _MagangFormPageState extends State<MagangFormPage> {
//   int _currentStep = 0;

//   List<Widget> _steps = [
//     MagangFormPersonal(),
//     MagangFormEducation(),
//     MagangFormSubmission(),
//   ];

//   void _nextStep() {
//     setState(() {
//       if (_currentStep < _steps.length - 1) {
//         _currentStep++;
//       }
//     });
//   }

//   void _previousStep() {
//     setState(() {
//       if (_currentStep > 0) {
//         _currentStep--;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Magang/KP Registration'),
//       ),
//       body: _steps[_currentStep],
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             if (_currentStep > 0)
//               TextButton(
//                 onPressed: _previousStep,
//                 child: Text('Back'),
//               ),
//             TextButton(
//               onPressed: _nextStep,
//               child: Text(_currentStep < _steps.length - 1 ? 'Next' : 'Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
