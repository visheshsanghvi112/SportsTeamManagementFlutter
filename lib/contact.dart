import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactDetails('Director of Sports Committee', 'Bhalchandra Savardekar Sir', 'assets/sportsday.jpg'),
            const SizedBox(height: 20),
            const Text(
              'Core Committee:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCoreCommitteeMember(
              'Security',
              'HOD: John Doe',
              'Co-HOD: Jane Doe',
              'assets/hsnc_logo.png',
            ),
            _buildCoreCommitteeMember(
              'Logistics',
              'HOD: Michael Smith',
              'Co-HOD: Emily Johnson',
              'assets/instagram_icon.png',
            ),
            _buildCoreCommitteeMember(
              'Event Management',
              'HOD: Robert Williams',
              'Co-HOD: Jessica Brown',
              'assets/img1.png',
            ),
            _buildCoreCommitteeMember(
              'Coverage',
              'HOD: William Johnson',
              'Co-HOD: Sophia Martinez',
              'assets/logo.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactDetails(String title, String name, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCoreCommitteeMember(String department, String hod, String coHod, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          department,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hod,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  coHod,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
