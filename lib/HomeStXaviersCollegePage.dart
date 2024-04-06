import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'DashboardPage.dart';
import 'news.dart';
import 'team.dart';
import 'events.dart';
import 'settings_page.dart';
import 'AboutUsPage.dart';
import 'theme_provider.dart';

class HomeStXaviersCollegePage extends StatefulWidget {
  const HomeStXaviersCollegePage({Key? key}) : super(key: key);

  @override
  _HomeStXaviersCollegePageState createState() =>
      _HomeStXaviersCollegePageState();
}

class _HomeStXaviersCollegePageState
    extends State<HomeStXaviersCollegePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const DashboardPage(isAdmin: true), // Pass your isAdmin logic here
    const NewsPage(),
    TeamPage(),
    const EventsPage(),
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            Expanded( // Wrap the Row with Expanded
              child: Text(
                'Xaviers College Home',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeProvider.isDarkMode
                  ? [Colors.black87, Colors.black]
                  : [Colors.orange.shade100, Colors.orange.shade800],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      floatingActionButton: CustomFAB(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutUsPage()),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(Icons.dashboard, 0),
            _buildNavBarItem(Icons.new_releases, 1),
            const SizedBox(),
            _buildNavBarItem(Icons.people, 2),
            _buildNavBarItem(Icons.event, 3),
          ].map((item) => Expanded(child: item)).toList(), // Wrap with Expanded
        ),
      ),
    );
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error signing out: $e');
      // Handle sign-out error
    }
  }

  Widget _buildNavBarItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => _onTabTapped(index),
      color: _currentIndex == index ? Colors.orange.shade300 : Colors.grey,
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFAB({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.orange.shade300,
      child: Image.asset('assets/xaviers.png'),
    );
  }
}
