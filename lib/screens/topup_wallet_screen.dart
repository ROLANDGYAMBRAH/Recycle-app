import 'package:flutter/material.dart';

class TopUpWalletScreen extends StatelessWidget {
  const TopUpWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/wallet_illustration.png',
                  height: 140,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Top Up Your\nWallet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002733),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Having balance helps you pay\ncollectors instantly and build trust.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Touchable Mobile Money Box
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/depositMobileMoney');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDFFFE3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Recommended',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF00994C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Mobile Money',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002733),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Instant – 30 minutes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Fee  GH₵100 – GH₵300',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Skip for Now Button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home'); // Adjust route as needed
                },
                child: const Text(
                  'Skip for Now',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF002733),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
