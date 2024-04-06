import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _sportController = TextEditingController();
  TextEditingController _achievementsController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final userDoc = await _firestore.collection('profile').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _heightController.text = userData['height'] ?? '';
          _weightController.text = userData['weight'] ?? '';
          _sportController.text = userData['sport'] ?? '';
          _achievementsController.text = userData['achievements'] ?? '';
          _locationController.text = userData['location'] ?? '';
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        try {
          final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
          await storageRef.putFile(_image!);
          final imageUrl = await storageRef.getDownloadURL();
          print('Image uploaded successfully. URL: $imageUrl');
          await _firestore.collection('profile').doc(userId).set({
            'profileImageUrl': imageUrl,
          }, SetOptions(merge: true));
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
    }
  }

  Future<void> _saveUserData() async {
    setState(() {
      _isLoading = true;
    });

    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        await _firestore.collection('profile').doc(userId).set({}, SetOptions(merge: true));
        await _firestore.collection('profile').doc(userId).update({
          'name': _nameController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'sport': _sportController.text,
          'achievements': _achievementsController.text,
          'location': _locationController.text,
        });
      } catch (e) {
        print('Error updating user data: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHeader(),
            const Divider(),
            _buildProfileDetails(),
            const Divider(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 60,
          backgroundImage: _image != null ? FileImage(_image!) : null,
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await _pickImage();
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

  Widget _buildProfileDetails() {
    return Column(
      children: [
        _buildDetailsRow(title: "Name", valueController: _nameController, hint: 'Enter your name'),
        _buildDetailsRow(title: "Height", valueController: _heightController, hint: 'Enter your height'),
        _buildDetailsRow(title: "Weight", valueController: _weightController, hint: 'Enter your weight'),
        _buildDetailsRow(title: "Sport", valueController: _sportController, hint: 'Enter your sport'),
        _buildDetailsRow(title: "Achievements", valueController: _achievementsController, hint: 'Enter your achievements'),
        _buildDetailsRow(title: "Location", valueController: _locationController, hint: 'Enter your Location'),
      ],
    );
  }

  Widget _buildDetailsRow({required String title, TextEditingController? valueController, required String hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: valueController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: hint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
        await _uploadImage();
        await _saveUserData();
        _loadUserData();
      },
      child: _isLoading ? const CircularProgressIndicator() : const Text('Save Changes'),
    );
  }
}
