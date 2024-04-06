import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'ForgotPasswordPage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme_provider.dart'; // Import your theme provider here

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
  }

  void _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  void _saveRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Scaffold(
          backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            title: Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.white : Colors.blue,
              ),
            ),
            backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: _buildBody(themeProvider),
          ),
        );
      },
    );
  }

  Widget _buildBody(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(26.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeProvider.isDarkMode ? Colors.black : Colors.white,
            themeProvider.isDarkMode ? Colors.black : Colors.white,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/finallogo.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 24),
          _buildTextField('Email', _emailController),
          const SizedBox(height: 16),
          _buildTextField('Password', _passwordController, isPassword: true),
          const SizedBox(height: 16),
          _buildRememberMeCheckbox(),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Navigate to Forgot Password Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
              );
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSignInButton(),
          const SizedBox(height: 16),
          _buildSignUpButton(),
          const SizedBox(height: 16),
          _buildAnimatedText(),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
      ),
      obscureText: isPassword && !_isPasswordVisible,
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value!;
            });
          },
          activeColor: Colors.blue,
        ),
        const Text(
          'Remember Me',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        _saveRememberMeStatus(); // Save remember me status
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        // Basic email validation
        if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(
            email)) {
          Fluttertoast.showToast(msg: 'Invalid email format');
          return;
        }

        // Basic password validation
        if (password.isEmpty) {
          Fluttertoast.showToast(msg: 'Please enter a password');
          return;
        }

        try {
          UserCredential userCredential = await _auth
              .signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          User user = userCredential.user!;
          print('Signed in: ${user.uid}');

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Successful!'),
              duration: Duration(seconds: 2),
            ),
          );

          // Fetch user data from Firestore
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          // Check if user data exists
          if (userSnapshot.exists) {
            // Retrieve the user's college from Firestore
            String college = userSnapshot['college'];

            // Redirect to the specific college dashboard based on the user's college
            switch (college) {
              case 'St. Xavier’s College':
                Navigator.pushReplacementNamed(context, '/HomeStXaviersCollege');
                break;
              case 'Wilson College':
                Navigator.pushReplacementNamed(context, '/HomeWilsonCollege');
                break;
              case 'Jai Hind College':
                Navigator.pushReplacementNamed(context, '/HomeJaiHindCollege');
                break;
              case 'ELPHINSTONE COLLEGE':
                Navigator.pushReplacementNamed(context, '/HomeJaiHindCollege');
                break;
              case 'H.R. College Of Commerce And Economics':
                Navigator.pushReplacementNamed(context, '/HomeJaiHindCollege');
                break;
              case 'RD National college':
                Navigator.pushReplacementNamed(context, '/HomeJaiHindCollege');
                break;
              case 'Lala Lajpat Rai College':
                Navigator.pushReplacementNamed(context, '/HomeJaiHindCollege');
                break;
              default:
              // Redirect to a default page if the user's college is not found
                Navigator.pushReplacementNamed(context, '/phoneauth');
            }
          } else {
            print('User data not found');
            // Handle the case where user data is not found
          }

        } catch (e) {
          print('Error signing in: $e');
          Fluttertoast.showToast(msg: 'Error signing in: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        // Navigate to Signup Page
        Navigator.pushNamed(context, '/signup');
      },
      child: const Text(
        'Don\'t have an account? Sign Up',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAnimatedText() {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.blue,
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
              'Welcome back!', speed: const Duration(milliseconds: 200)),
          TyperAnimatedText(
              'Login to your account', speed: const Duration(milliseconds: 200)),
        ],
        isRepeatingAnimation: true, // Set this to true for an infinite loop
      ),
    );
  }
}
