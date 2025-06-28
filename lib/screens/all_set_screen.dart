import 'package:flutter/material.dart';

class AllSetScreen extends StatelessWidget {
  const AllSetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 46),
                const Text(
                  "You're All Set!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF11333D),
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Welcome to Recycle App.\nStart earning by recycling near you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF34495E),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Image.asset(
                  'assets/images/welcome.png',
                  height: 210,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/collector_signing');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38B000),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Go to Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/collector_signing');
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Color(0xFF34495E),
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: Color(0xFF38B000),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
