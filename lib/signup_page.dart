import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<String> collegeNames = [
    'Wilson College',
    'Kishinchand Chellaram College',
    'Jai Hind College',
    'St. Xavier’s College',
    'ELPHINSTONE COLLEGE',
    'H.R. College Of Commerce And Economics',
    'Mithibai College',
    'RD National college',
    'Lala Lajpat Rai College',
  ];

  String selectedCollege = 'Wilson College';
  String selectedUniversity = 'Mumbai University';
  String selectedUserRole = 'User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/hsnc_logo.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField('Email', _emailController),
            const SizedBox(height: 16),
            _buildTextField('Password', _passwordController, isPassword: true),
            const SizedBox(height: 16),
            _buildDropdown(
              'College',
              selectedCollege,
              collegeNames,
                  (String? value) {
                setState(() {
                  selectedCollege = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'University',
              selectedUniversity,
              ['Mumbai University', 'HSNCUniversity'],
                  (String? value) {
                setState(() {
                  selectedUniversity = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'User Role',
              selectedUserRole,
              ['Admin', 'User'],
                  (String? value) {
                setState(() {
                  selectedUserRole = value ?? '';
                });
              },
            ),
            const SizedBox(height: 32),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, void Function(String?) onChanged) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      hint: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () async {
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          _showSnackBar('Please enter valid email and password');
          return;
        }

        // Validate that only one admin is allowed for each college
        if (selectedUserRole == 'Admin' && await isCollegeAdmin(selectedCollege)) {
          _showSnackBar('An admin already exists for $selectedCollege');
          return;
        }

        try {
          // Create user in Firebase Authentication
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          User user = userCredential.user!;
          print('Signed up: ${user.uid}');

          // Add user data to Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'email': email,
            'college': selectedCollege,
            'university': selectedUniversity,
            'userRole': selectedUserRole,
          });

          // If the user is an admin, also add them to the 'admins' collection
          if (selectedUserRole == 'Admin') {
            await _firestore.collection('admins').doc(selectedCollege).set({
              'email': email,
              'college': selectedCollege,
            });
          }

          // Show success message
          _showSnackBar('Signed up successfully!');

          // Navigate to Login Page after successful signup
          Navigator.pushReplacementNamed(context, '/login');
        } catch (e) {
          print('Error signing up: $e');
          _showSnackBar('Error signing up. Please try again later.');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<bool> isCollegeAdmin(String college) async {
    DocumentSnapshot adminSnapshot = await _firestore.collection('admins').doc(college).get();
    return adminSnapshot.exists;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
