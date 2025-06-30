// File: lib/screens/collector_signing_screen.dart
import 'package:flutter/material.dart';
import 'collector_home_screen.dart';

class CollectorSigningScreen extends StatefulWidget {
  const CollectorSigningScreen({Key? key}) : super(key: key);

  @override
  State<CollectorSigningScreen> createState() => _CollectorSigningScreenState();
}

class _CollectorSigningScreenState extends State<CollectorSigningScreen> {
  int selectedTab = 0;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Recycle App',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF11333D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/lady.png',
                width: 160,
                height: 140,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              const Text(
                'Sign in as a Collector',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF11333D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTab('Login', 0),
                  const SizedBox(width: 36),
                  _buildTab('Sign Up', 1),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Image.asset('assets/images/ghana_flag.png', width: 26, height: 18, fit: BoxFit.cover),
                    const SizedBox(width: 7),
                    const Text('+233', style: TextStyle(fontSize: 16, color: Color(0xFF333333), fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: Color(0xFF9EA6AE)),
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Color(0xFF9EA6AE)),
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF9EA6AE), size: 24),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/google_icon.png', width: 24, height: 24),
                      const SizedBox(width: 8),
                      const Text('Sign in with Google',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Color(0xFF444444))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () {},
                child: const Align(
                  alignment: Alignment.center,
                  child: Text('Forgot password?',
                      style: TextStyle(fontSize: 16, color: Color(0xFF607180), fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CollectorHomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B000),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: const Text('Continue',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.1)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('By continuing, you agree to our ',
                      style: TextStyle(color: Color(0xFF8A98A8), fontSize: 14)),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('Terms of',
                        style: TextStyle(color: Color(0xFF38B000), fontWeight: FontWeight.bold, fontSize: 14, decoration: TextDecoration.underline)),
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('Service',
                        style: TextStyle(color: Color(0xFF38B000), fontWeight: FontWeight.bold, fontSize: 14, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, int tabIndex) {
    final isActive = selectedTab == tabIndex;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = tabIndex),
      child: Column(
        children: [
          Text(text,
              style: TextStyle(
                color: isActive ? const Color(0xFF11333D) : const Color(0xFFB6C0C9),
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                fontSize: 20,
              )),
          const SizedBox(height: 5),
          Container(
            height: 2.6,
            width: 44,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF11333D) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
