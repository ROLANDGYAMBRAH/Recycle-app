import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> _saveTransaction(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add({
        'type': 'deposit',
        'mobileNumber': mobileNumber,
        'provider': mobileProvider,
        'amount': amount,
        'commission': commission,
        'finalAmount': amount - commission,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending', // you can later update as 'completed'
      });

      // Go to the next screen
      Navigator.pushNamed(context, '/completePayment');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save transaction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double receiveAmount = amount - commission;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Confirm Deposit',
          style: TextStyle(
            color: Color(0xFF002733),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
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
                  onPressed: () => _saveTransaction(context),
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
