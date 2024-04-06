import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'phoneauth.dart';
import 'firebase_options.dart';
import 'landing_screen.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'signup_page.dart';
import 'HomeElphinstoneCollegePage.dart';
import 'HomeHRCollegePage.dart';
import 'HomeJaiHindCollegePage.dart';
import 'HomeKishinchandChellaramPage.dart';
import 'HomeLalaLajpatRaiCollegePage.dart';
import 'HomeMithibaiCollegePage.dart';
import 'HomeRDNationalCollegePage.dart';
import 'HomeStXaviersCollegePage.dart';
import 'HomeWilsonCollegePage.dart';
import 'theme_provider.dart';
import 'welcome_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Analytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Enable analytics collection
  await analytics.setAnalyticsCollectionEnabled(true);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'My Flutter App',
          theme: ThemeData.light(), // Set initial theme to light
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light, // Always use light theme initially
          initialRoute: '/landingscreen', // Change the initial route to '/login'
          routes: {
            '/login': (context) => const LoginPage(),
            '/welcome': (context) => WelcomePage(),
            '/home': (context) => const HomePage(),
            '/signup': (context) => const SignupPage(),
            '/HomeWilsonCollege': (context) => const HomeWilsonCollegePage(),
            '/HomeKishinchandChellaram': (context) =>
            const HomeKishinchandChellaramPage(),
            '/HomeJaiHindCollege': (context) => const HomeJaiHindCollegePage(),
            '/HomeLalaLajpatRaiCollege': (context) =>
            const HomeLalaLajpatRaiCollegePage(),
            '/HomeMithibaiCollege': (context) => const HomeMithibaiCollegePage(),
            '/HomeNationalCollege': (context) =>
            const HomeRDNationalCollegePage(),
            '/phoneauth': (context) => const PhoneAuthScreen(),
            '/landingscreen': (context) => LandingScreen(),
            '/HRCollege': (context) => const HomeHRCollegePage(),
            '/KishinchandChellaram': (context) =>
            const HomeKishinchandChellaramPage(),
            '/JaiHindCollege': (context) => const HomeJaiHindCollegePage(),
            '/ElphinstoneCollege': (context) =>
            const HomeElphinstoneCollegePage(),
            '/HomeStXaviersCollege': (context) => const HomeStXaviersCollegePage(),

          },
        );
      },
    );
  }
}
