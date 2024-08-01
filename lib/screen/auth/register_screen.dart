import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 100),
                  const LogoAndText(),
                  const SizedBox(height: 20),
                  const InputWrapper(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputWrapper extends StatefulWidget {
  const InputWrapper({Key? key}) : super(key: key);

  @override
  _InputWrapperState createState() => _InputWrapperState();
}

class _InputWrapperState extends State<InputWrapper> {
  String _selectedRole = 'pelajar';
  bool _isHoveringInput = false;
  bool _isHoveringDropdown = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          _buildInputField("Username"),
          const SizedBox(height: 20),
          _buildInputField("Email"),
          const SizedBox(height: 20),
          _buildRoleDropdown(),
          const SizedBox(height: 20),
          _buildPasswordField("Password"),
          const SizedBox(height: 20),
          _buildPasswordField("Confirm Password"),
          const SizedBox(height: 30),
          Container(
            width: 150,
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
                // Add functionality for registration button here
              },
              child: const Text(
                "Register",
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
    );
  }

  Widget _buildInputField(String hint) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringInput = true),
      onExit: (_) => setState(() => _isHoveringInput = false),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _isHoveringInput ? Colors.blue : Colors.black, width: 2),
          boxShadow: _isHoveringInput ? [BoxShadow(color: Colors.blue, blurRadius: 10)] : [],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringInput = true),
      onExit: (_) => setState(() => _isHoveringInput = false),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _isHoveringInput ? Colors.blue : Colors.black, width: 2),
          boxShadow: _isHoveringInput ? [BoxShadow(color: Colors.blue, blurRadius: 10)] : [],
        ),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringDropdown = true),
      onExit: (_) => setState(() => _isHoveringDropdown = false),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _isHoveringDropdown ? Colors.blue : Colors.black, width: 2),
          boxShadow: _isHoveringDropdown ? [BoxShadow(color: Colors.blue, blurRadius: 10)] : [],
        ),
        child: DropdownButton<String>(
          value: _selectedRole,
          isExpanded: true,
          underline: SizedBox(),
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
          dropdownColor: Colors.white,
          items: <String>['pelajar', 'mahasiswa'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.grey)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue!;
            });
          },
        ),
      ),
    );
  }
}

class LogoAndText extends StatelessWidget {
  const LogoAndText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Image.asset(
            'asset/logo_pln_icon_plus.jpeg',
            width: 150,
            height: 150,
          ),
        ),
        const Positioned(
          bottom: 0,
          child: Text(
            "Internship",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
      ],
    );
  }
}
