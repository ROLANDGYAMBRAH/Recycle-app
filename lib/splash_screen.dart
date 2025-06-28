import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate after 4 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                width: 280,
                height: 280,
                child: Image.asset(
                  'assets/images/recycle_logo.png',
                  fit: BoxFit.contain,
                ),
              ),

              // Title - positioned directly under logo with minimal spacing
              Transform.translate(
                offset: const Offset(0, -30), // Move text up to be very close to logo
                child: const Text(
                  'Recycle App',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF144A3F),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Subtitle with proper spacing from title
              Transform.translate(
                offset: const Offset(0, -24), // Adjust subtitle position
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    "Connecting Ghana's recyclers,\none deal at a time",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF144A3F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}