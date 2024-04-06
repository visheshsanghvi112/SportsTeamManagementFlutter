import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'settings_page.dart';
import 'theme_provider.dart';
import 'AboutUsPage.dart';
import 'DashboardPage.dart';
import 'news.dart';
import 'team.dart';
import 'events.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: const Text('Home'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeProvider.isDarkMode ? [Colors.grey.shade900, Colors.black] : [Colors.purple.shade100, Colors.purple.shade800],
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
            onPressed: () async {
              // Sign out
              await _auth.signOut();
              print('Signed out');

              // Navigate to Login Page after signing out
              Navigator.pushReplacementNamed(context, '/login');
            },
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
            IconButton(
              icon: const Icon(Icons.dashboard),
              onPressed: () => _onTabTapped(0),
              color: _currentIndex == 0 ? Colors.purple.shade300 : Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.new_releases),
              onPressed: () => _onTabTapped(1),
              color: _currentIndex == 1 ? Colors.purple.shade300 : Colors.grey,
            ),
            const SizedBox(), // Empty space for the floating action button
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () => _onTabTapped(2),
              color: _currentIndex == 2 ? Colors.purple.shade300 : Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.event),
              onPressed: () => _onTabTapped(3),
              color: _currentIndex == 3 ? Colors.purple.shade300 : Colors.grey,
            ),
          ],
        ),
      ),
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
      backgroundColor: Colors.purple.shade300,
      child: Image.asset('assets/hsnc_logo.png'),
    );
  }
}
