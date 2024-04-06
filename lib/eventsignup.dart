import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventSignUpPage extends StatefulWidget {
  final String eventName;

  EventSignUpPage({required this.eventName});

  @override
  _EventSignUpPageState createState() => _EventSignUpPageState();
}

class _EventSignUpPageState extends State<EventSignUpPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  TextEditingController _rollNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String _selectedSport = 'Cricket';

  List<String> sports = ['Cricket', 'Football', 'Basketball', 'Tennis', 'Kabaddi', 'Chess', 'Carrom'];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Sign-Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign up for ${widget.eventName}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedSport,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSport = newValue!;
                      });
                    },
                    items: sports
                        .map<DropdownMenuItem<String>>(
                          (String sport) => DropdownMenuItem<String>(
                        value: sport,
                        child: Row(
                          children: [
                            Icon(
                              getSportIcon(sport),
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 10),
                            Text(sport),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _nameController,
                  labelText: 'Your Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _rollNumberController,
                  labelText: 'Your Roll Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your roll number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _emailController,
                  labelText: 'Your Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Add more validation for email format if needed
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _phoneController,
                  labelText: 'Your Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Add more validation for phone number format if needed
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _addressController,
                  labelText: 'Your Address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _classController,
                  labelText: 'Your Class',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your class';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _performSignUp();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Sign Up',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSportDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedSport,
        onChanged: (newValue) {
          setState(() {
            _selectedSport = newValue!;
          });
        },
        items: sports.map((sport) => _buildDropdownItem(sport)).toList(),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String sport) {
    return DropdownMenuItem<String>(
      value: sport,
      child: Row(
        children: [
          Icon(
            getSportIcon(sport),
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(sport),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  String? _validateField(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _performSignUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Sign Up',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _performSignUp() async {
    try {
      if (_formKey.currentState!.validate()) {
        String userName = _nameController.text;
        String userRollNumber = _rollNumberController.text;
        String userEmail = _emailController.text;
        String userPhone = _phoneController.text;
        String userAddress = _addressController.text;
        String userClass = _classController.text;
        String selectedSport = _selectedSport;

        await _firestore.collection('eventsignup').add({
          'yourname': userName,
          'rollno': userRollNumber,
          'email': userEmail,
          'phone': int.parse(userPhone),
          'address': userAddress,
          'yourclass': userClass,
          'sport': selectedSport,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign-up successful!'),
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.pushReplacementNamed(context, '/profile');
      }
    } catch (e) {
      print('Error signing up: $e');
      _showErrorMessage('Error signing up. Please try again.');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  IconData getSportIcon(String sport) {
    switch (sport) {
      case 'Cricket':
        return Icons.sports_cricket;
      case 'Football':
        return Icons.sports_soccer;
      case 'Basketball':
        return Icons.sports_basketball;
      case 'Tennis':
        return Icons.sports_tennis;
      case 'Kabaddi':
        return Icons.sports_kabaddi;
      case 'Chess':
        return Icons.gamepad;
      case 'Carrom':
        return Icons.sports_handball;
      default:
        return Icons.sports;
    }
  }
}
