import 'package:flutter/material.dart';

class ConfirmDepositScreen extends StatelessWidget {
  final String mobileNumber;
  final String mobileProvider;
  final double amount;
  final double commission;

  const ConfirmDepositScreen({
    super.key,
    required this.mobileNumber,
    required this.mobileProvider,
    required this.amount,
    this.commission = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final double receiveAmount = amount - commission;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/confirm_deposit_illustration.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Confirm Deposit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002733),
                ),
              ),
              const SizedBox(height: 28),

              // Details
              _infoRow('Payment Method', 'Mobile Money'),
              _divider(),
              _infoRow('Mobile Number', mobileNumber),
              _divider(),
              _infoRow('Mobile Provider', mobileProvider),
              _divider(),
              _infoRow('Amount to Deposit', 'GH₵${amount.toStringAsFixed(0)}'),
              _divider(),
              _infoRow('You Will Receive:', 'GH₵${receiveAmount.toStringAsFixed(0)}'),
              _divider(),
              _infoRow('Commission', '${(commission * 100).toStringAsFixed(0)}%'),
              const Spacer(),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/completePayment');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Confirm & Send Request',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              )),
          Text(value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 24, color: Colors.black12);
  }
}
