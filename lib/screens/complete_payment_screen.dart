import 'package:flutter/material.dart';

class CompletePaymentScreen extends StatefulWidget {
  const CompletePaymentScreen({super.key});

  @override
  State<CompletePaymentScreen> createState() => _CompletePaymentScreenState();
}

class _CompletePaymentScreenState extends State<CompletePaymentScreen> {
  int selectedRating = 0;

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= selectedRating ? Icons.star : Icons.star_border,
        color: Colors.orange,
        size: 30,
      ),
      onPressed: () {
        setState(() {
          selectedRating = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Illustration
              Center(
                child: Image.asset(
                  'assets/images/complete_payment_illustration.png', // Replace with actual image
                  height: 140,
                ),
              ),
              const SizedBox(height: 24),

              // Heading
              const Text(
                'Complete your\npayment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002733),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),

              // Subtext
              const Text(
                'Your payment request has been\nsent to MTN.\nTo complete the payment, please\ncheck your phone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // View History Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/transactionHistory');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'View History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // New Deposit
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/depositMobileMoney'));
                },
                child: const Text(
                  'New Deposit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF002733),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Rating
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'How was your payment experience?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (int i = 1; i <= 5; i++) buildStar(i),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Handle skip
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
