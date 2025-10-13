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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const DashboardPage(isAdmin: true), // Pass your isAdmin logic here
    const NewsPage(),
    TeamPage(),
    const EventsPage(),
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final List<String> _pageTitles = ['Dashboard', 'News', 'Teams', 'Events'];

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        shadowColor: Colors.purple.withOpacity(0.5),
        title: Text(
          _pageTitles[_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeProvider.isDarkMode 
                ? [Colors.grey.shade900, Colors.black] 
                : [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Sign Out',
              onPressed: () async {
                // Sign out
                await _auth.signOut();
                print('Signed out');

                // Navigate to Login Page after signing out
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.elasticOut,
        ),
        child: CustomFAB(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutUsPage()),
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 16,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white,
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.dashboard_rounded, 'Dashboard'),
              _buildNavItem(1, Icons.article_rounded, 'News'),
              const SizedBox(width: 48), // Empty space for the floating action button
              _buildNavItem(2, Icons.people_rounded, 'Teams'),
              _buildNavItem(3, Icons.event_rounded, 'Events'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? const Color(0xFF6A1B9A).withOpacity(0.15)
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected 
                    ? const Color(0xFF6A1B9A)
                    : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: isSelected ? 12 : 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected 
                    ? const Color(0xFF6A1B9A)
                    : Colors.grey.shade500,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _fabController.reset();
      _fabController.forward();
    }
  }
}

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFAB({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        elevation: 6,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/hsnc_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
