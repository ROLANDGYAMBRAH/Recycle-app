import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/recycle_logo.png'),
              width: 120,
            ),
            SizedBox(height: 30),
            Text(
              'Recycle App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4332),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Connecting Ghana’s recyclers,\none deal at a time",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF2D6A4F),
              ),
            ),
            SizedBox(height: 50),
            CircularProgressIndicator(
              color: Color(0xFF2D6A4F),
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}
