import 'package:flutter/material.dart';
import 'login_page.dart';
import 'ProfilePage.dart';
import 'eventsignup.dart';
import 'landing_screen.dart';
// Import the PdfUploadPage file
import 'dart:io';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // Sample data for dynamic sections
  final List<String> upcomingEvents = ['Football Match - Tomorrow at 3 PM', 'Basketball Tournament - Next Week'];
  final List<String> recentResults = ['Football Match - Won', 'Basketball Tournament - Runner-up'];
  final List<String> newsAndAnnouncements = ['New Coach Announcement', 'Team Meeting - Next Week'];

  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Event Overview'),
            _buildEventOverview(),

            _buildSectionTitle('Registration Section'),
            _buildRegistrationSection(context),

            _buildSectionTitle('Recent Results'),
            _buildRecentResults(),

            _buildSectionTitle('News and Announcements'),
            _buildNewsAndAnnouncements(),

            _buildSectionTitle('PDF Upload (Admin Only)'),
            _buildPdfUploadSection(),

            _buildSectionTitle('Quick Links'),
            _buildQuickLinks(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEventOverview() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: upcomingEvents.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Event ${index + 1}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    upcomingEvents[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegistrationSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Register for Events:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventSignUpPage(eventName: 'Your Event Name')),
              );
            },
            child: const Text('Sign Up for Events'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentResults() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Results:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          for (String result in recentResults)
            Text(
              result,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildNewsAndAnnouncements() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'News and Announcements:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          for (String news in newsAndAnnouncements)
            Text(
              news,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildPdfUploadSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.deepOrange, // Customize the color as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PDF Upload (Admin Only):',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              File? pickedFile = await _pickFile();
              if (pickedFile != null) {
                setState(() {
                  _selectedFile = pickedFile;
                });
              }
            },
            child: const Text('Pick PDF'),
          ),
          if (_selectedFile != null)
            Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Selected File:',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedFile!.path,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Admin-specific logic for uploading the selected PDF file
                    // You can implement your own logic here based on your storage solution
                    // For example, you can use Firebase Storage, AWS S3, etc.
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => PdfUploadPage(selectedFile: _selectedFile!),
                    //   ),
                    // );
                  },
                  child: const Text('Upload PDF'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<File?> _pickFile() async {
    // Implement your file picking logic here
    // This example uses the file_picker package
    // Make sure to add the file_picker dependency to your pubspec.yaml file
    // Example: file_picker: ^4.1.4
    // https://pub.dev/packages/file_picker
    // FilePickerResult? result = await FilePicker.platform.pickFiles();
    // return result?.files.first?.path;

    // This is a placeholder since the file_picker package is not added in this example
    // Replace this with your actual file picking logic
    return null;
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Links:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Sign In'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: const Text('Profile'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingScreen()),
              );
            },
            child: const Text('Visit Landing Screen'),
          ),
        ],
      ),
    );
  }
}
