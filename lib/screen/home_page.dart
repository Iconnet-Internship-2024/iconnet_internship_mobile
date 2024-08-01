// import 'package:flutter/material.dart';
// import 'package:iconnet_internship_mobile/utils/colors.dart';
// import 'package:iconnet_internship_mobile/screen/component/navbar.dart';
// import 'package:iconnet_internship_mobile/screen/magang_form/magang_form_personal.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Future<bool> _onWillPop() async {
//     return (await Navigator.of(context).maybePop()) || false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: primaryColors,
//           title: const Text(
//             'PLN Icon Plus Internship',
//             style: TextStyle(color: Colors.white),
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.menu),
//             onPressed: () {
//               _scaffoldKey.currentState?.openDrawer();
//             },
//             color: Colors.white,
//           ),
//           iconTheme: const IconThemeData(color: Colors.white),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MagangFormPersonal()),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                   child: Container(
//                     width: double.infinity,
//                     height: 200,
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.black, width: 3),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(
//                           Icons.school,
//                           size: 80,
//                           color: Colors.black,
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Magang/Kerja Praktik',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 50),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MagangFormPersonal()),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Container(
//                     width: double.infinity,
//                     height: 200,
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.black, width: 3),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(
//                           Icons.book,
//                           size: 80,
//                           color: Colors.black,
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'PKL',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 50),
//             ],
//           ),
//         ),
//         drawer: Navbar(
//           selectedIndex: _selectedIndex,
//           onItemTapped: _onItemTapped,
//         ),
//       ),
//     );
//   }
// }
