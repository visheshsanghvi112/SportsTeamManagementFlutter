import 'package:flutter/material.dart';
import 'FeedbackForm.dart';
import 'sports_team_chatbot.dart';
import 'contact.dart'; // Import the contact.dart page

class AboutUsPage extends StatelessWidget {
  final List<SectionData> sectionsData = [
    SectionData('Team Achievements', 'Your achievements content goes here.'),
    SectionData('Contact Information', 'Your contact information goes here.'),
    SectionData('App Information', 'Your app information goes here.'),
    SectionData('Provide Feedback', 'Provide feedback about our app.'),
    SectionData('Sports Team Chatbot', 'Your Sports Team Chatbot content goes here.'),
  ];

  @override
  Widget build(BuildContext context) {
    final Color purple800 = Colors.purple.shade800;
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        elevation: 0,
        backgroundColor: purple800, // Use the specified purple color
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: purple800, // Use the specified purple color
              ),
              child: const Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Home',
                style: TextStyle(color: purple800), // Use the specified purple color
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            for (SectionData section in sectionsData)
              ListTile(
                title: Text(
                  section.title,
                  style: TextStyle(color: purple800), // Use the specified purple color
                ),
                onTap: () {
                  _navigateToSection(context, section);
                },
              ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: ListView(
          children: sectionsData
              .map((section) => _buildSectionCard(context, section))
              .toList(),
        ),
      ),
    );
  }

  void _navigateToSection(BuildContext context, SectionData section) {
    if (section.title == 'Contact Information') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactPage()), // Use the ContactPage from contact.dart
      );
    } else if (section.title == 'Provide Feedback') {
      _navigateToFeedbackForm(context);
    } else if (section.title == 'Sports Team Chatbot') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InnerPage(section)),
      );
    }
  }

  Widget _buildSectionCard(BuildContext context, SectionData section) {
    final Color purple800 = Colors.purple.shade800;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: ListTile(
        title: Text(
          section.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: purple800), // Use the specified purple color
        ),
        onTap: () {
          _navigateToSection(context, section);
        },
      ),
    );
  }

  void _navigateToFeedbackForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackForm(
          onSubmit: (feedback, rating, feedbackType) => _submitFeedback(feedback),
        ),
      ),
    );
  }

  void _submitFeedback(String feedback) {
    // Process the submitted feedback here
    print('Feedback submitted: $feedback');
    // You can handle the submitted feedback as per your requirement, such as sending it to a server, storing it locally, etc.
  }
}

class InnerPage extends StatelessWidget {
  final SectionData section;

  InnerPage(this.section);

  @override
  Widget build(BuildContext context) {
    final Color purple800 = Colors.purple.shade800;
    return Scaffold(
      appBar: AppBar(
        title: Text(section.title),
        backgroundColor: purple800, // Use the specified purple color
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: Card(
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              section.content,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionData {
  final String title;
  final String content;

  SectionData(this.title, this.content);
}
