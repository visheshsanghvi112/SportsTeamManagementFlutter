import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    // Show message that Google Sign In is coming soon
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign In coming soon! Please use email login for now 😊'),
        backgroundColor: Color(0xFF6A1B9A),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navigate to email login after a brief delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6A1B9A),
              const Color(0xFF8E24AA),
              const Color(0xFFAB47BC),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background circles
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                left: -150,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              
              // Main content
              Center(
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo with glow effect
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 40,
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/finallogo.png',
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            
                            // Welcome text
                            const Text(
                              'Welcome to',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white70,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sports Team App',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Manage your team with excellence',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white60,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 60),
                            
                            // Google Sign In Button
                            _buildGoogleButton(),
                            const SizedBox(height: 16),
                            
                            // Divider
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.white30, thickness: 1)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.white30, thickness: 1)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Email Login Button
                            _buildButton(
                              icon: Icons.email_outlined,
                              label: 'Continue with Email',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              gradient: LinearGradient(
                                colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
                              ),
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: 12),
                            
                            // Sign Up Button
                            _buildButton(
                              icon: Icons.person_add_outlined,
                              label: 'Create New Account',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignupPage()),
                                );
                              },
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.white.withOpacity(0.9)],
                              ),
                              textColor: const Color(0xFF6A1B9A),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Loading overlay
              if (_isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A1B9A)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Signing in...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A1B9A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : () => _handleGoogleSignIn(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                  height: 24,
                  width: 24,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.g_mobiledata,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Gradient gradient,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: textColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
