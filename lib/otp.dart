import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart'; // Import your home page file

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen({Key? key, required this.phoneNumber, required this.verificationId})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer _timer;
  int _resendTimeout = 30; // Resend timeout in seconds
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_resendTimeout > 0) {
        setState(() {
          _resendTimeout--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  void _resendOtp() {
    if (_isResendEnabled) {
      // Implement resend logic here
      // You can call _verifyPhoneNumber() or your resend logic
      // Make sure to reset the timer after triggering a new OTP
      setState(() {
        _resendTimeout = 30;
        _isResendEnabled = false;
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Text(
                'Enter the OTP sent to ${widget.phoneNumber}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32.0),
            FadeIn(
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            SlideIn(
              duration: const Duration(milliseconds: 500),
              child: ElevatedButton(
                onPressed: _signInWithPhoneNumber,
                child: const Text('Verify OTP'),
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeIn(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    'Resend OTP in $_resendTimeout seconds',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8.0),
                _isResendEnabled
                    ? SlideIn(
                  duration: const Duration(milliseconds: 500),
                  child: ElevatedButton(
                    onPressed: _resendOtp,
                    child: const Text('Resend OTP'),
                  ),
                )
                    : const SizedBox(), // Use SizedBox for placeholder if resend is not enabled
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);

      // Navigate to the home page after successful verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (e) {
      print('Error signing in with phone number: $e');
      // Handle the error, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}

// Custom FadeIn animation widget
class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeIn({Key? key, required this.child, required this.duration}) : super(key: key);

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

// Custom SlideIn animation widget
class SlideIn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SlideIn({Key? key, required this.child, required this.duration}) : super(key: key);

  @override
  _SlideInState createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
