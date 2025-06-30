import 'package:flutter/material.dart';
import 'confirm_deposit_screen.dart'; // Import the confirmation screen

class DepositMobileMoneyScreen extends StatefulWidget {
  const DepositMobileMoneyScreen({super.key});

  @override
  State<DepositMobileMoneyScreen> createState() => _DepositMobileMoneyScreenState();
}

class _DepositMobileMoneyScreenState extends State<DepositMobileMoneyScreen> {
  String selectedProvider = 'MTN';
  final TextEditingController amountController = TextEditingController();

  double get amount => double.tryParse(amountController.text) ?? 0.0;

  double get commissionPercent {
    switch (selectedProvider) {
      case 'MTN':
        return 0.0;
      case 'AirtelTigo':
        return 0.02;
      case 'Telecel':
        return 0.015;
      default:
        return 0.0;
    }
  }

  double get commission => amount * commissionPercent;
  double get finalAmount => amount - commission;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Widget providerTile(String provider) {
    return GestureDetector(
      onTap: () => setState(() => selectedProvider = provider),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedProvider == provider ? Colors.green : Colors.grey.shade300,
            width: 1.8,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              selectedProvider == provider
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selectedProvider == provider ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              provider,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Navigate and pass data to the ConfirmDepositScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmDepositScreen(
          mobileNumber: 'MTN – 055 *** 1234',
          mobileProvider: selectedProvider,
          amount: amount,
          commission: commission,
        ),
      ),
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
              Center(
                child: Image.asset(
                  'assets/images/mobile_money_illustration.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Deposit with\nMobile Money',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002733),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '+233 *****321',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose your mobile provider',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              providerTile('MTN'),
              providerTile('AirtelTigo'),
              providerTile('Telecel'),
              const SizedBox(height: 16),

              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixText: 'GH₵ ',
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('You will receive: GH₵${finalAmount.toStringAsFixed(2)}'),
                    const SizedBox(height: 4),
                    Text('Commission: ${(commissionPercent * 100).toStringAsFixed(1)}%'),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
