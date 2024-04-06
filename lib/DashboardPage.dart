import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfilePage.dart';
import 'landing_screen.dart';
import 'eventsignup.dart';
import 'pdf_upload_page.dart';

class DashboardPage extends StatefulWidget {
  final bool isAdmin;

  const DashboardPage({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      backgroundColor: _isDarkMode ? Colors.black : Colors.white, // Set background color based on dark mode
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Registered Event Overview'),
            _buildEventOverview(),
            _buildSectionTitle('Matches '),
            _buildMatchCards(),
            _buildSectionTitle('Registration Section'),
            _buildRegistrationSection(context),
            if (widget.isAdmin) ...[
              _buildAdminSectionTitle('PDF Upload'),
              _buildPdfUploadSection(context),
            ],
            _buildClickableSectionTitle('User Profile', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            }),
            _buildClickableSectionTitle('Logout', () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LandingScreen()),
              );
            }),
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
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: _isDarkMode ? Colors.white : Colors.blue,
        ),
      ),
    );
  }

  Widget _buildEventOverview() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('eventsignup').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Or any other loading indicator
        }

        final registrations = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              final userName = registrations[index]['yourname'] as String;
              final eventName = registrations[index]['sport'] as String;
              return Card(
                elevation: 5.0,
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registration ${index + 1}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'User: $userName\nEvent: $eventName',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRegistrationSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[900] : Colors.green,
        borderRadius: BorderRadius.circular(15.0),
      ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Sign Up for Events',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSectionTitle(String title) {
    return _buildSectionTitle(title); // Admin section title can have the same style as regular section titles
  }

  Widget _buildPdfUploadSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[900] : Colors.deepOrange,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PDF Upload (Admin Only):',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PdfUploadPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Upload PDF',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableSectionTitle(String title, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: _buildSectionTitle(title),
    );
  }

  Widget _buildMatchCards() {
    return Column(
      children: [
        MatchCard(
          team1Name: 'Team 1',
          team2Name: 'Team 2',
          team1LogoPath: 'assets/hsnc_logo.png',
          team2LogoPath: 'assets/wilson.png',
          dateTime: DateTime.now().add(const Duration(hours: 2)),
        ),
        MatchCard(
          team1Name: 'Team 3',
          team2Name: 'Team 4',
          team1LogoPath: 'assets/hsnc_logo.png',
          team2LogoPath: 'assets/xaviers.png',
          dateTime: DateTime.now().add(const Duration(hours: 3)),
        ),
      ],
    );
  }
}

class MatchCard extends StatefulWidget {
  final String team1Name;
  final String team2Name;
  final String team1LogoPath;
  final String team2LogoPath;
  final DateTime dateTime;

  MatchCard({Key? key,
    required this.team1Name,
    required this.team2Name,
    required this.team1LogoPath,
    required this.team2LogoPath,
    required this.dateTime,
  }) : super(key: key);

  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  late Timer _timer;
  Duration _countdownDuration = const Duration();

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    if (widget.dateTime.isAfter(now)) {
      _countdownDuration = widget.dateTime.difference(now);
    } else {
      _countdownDuration = const Duration();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamColumn(widget.team1LogoPath, widget.team1Name),
                const Text(
                  'vs',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildTeamColumn(widget.team2LogoPath, widget.team2Name),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildTimerWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn(String logoPath, String teamName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          logoPath,
          width: 50,
          height: 50,
        ),
        const SizedBox(height: 8.0),
        Text(
          teamName,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerWidget() {
    if (_countdownDuration.inSeconds > 0) {
      // For upcoming match
      return Text(
        'Starts in: ${_formatDuration(_countdownDuration)}',
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      // For ongoing match
      return const Text(
        'Match in progress',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
