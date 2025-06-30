import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'confirm_deposit_screen.dart';

class DepositMobileMoneyScreen extends StatefulWidget {
  const DepositMobileMoneyScreen({super.key});

  @override
  State<DepositMobileMoneyScreen> createState() => _DepositMobileMoneyScreenState();
}

class _DepositMobileMoneyScreenState extends State<DepositMobileMoneyScreen> {
  String selectedProvider = 'MTN';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController mtnNumberController = TextEditingController();
  final TextEditingController airtelTigoNumberController = TextEditingController();
  final TextEditingController telecelNumberController = TextEditingController();
  bool isSubmitting = false;

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

  TextEditingController get activeNumberController {
    switch (selectedProvider) {
      case 'MTN':
        return mtnNumberController;
      case 'AirtelTigo':
        return airtelTigoNumberController;
      case 'Telecel':
        return telecelNumberController;
      default:
        return mtnNumberController;
    }
  }

  String get providerPlaceholder {
    switch (selectedProvider) {
      case 'MTN':
        return 'Enter your MTN number';
      case 'AirtelTigo':
        return 'Enter your AirtelTigo number';
      case 'Telecel':
        return 'Enter your Telecel number';
      default:
        return 'Enter your number';
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    mtnNumberController.dispose();
    airtelTigoNumberController.dispose();
    telecelNumberController.dispose();
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

  Future<void> _handleContinue() async {
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    String mobileNumber = activeNumberController.text.trim();
    if (mobileNumber.isEmpty || mobileNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid $selectedProvider number')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('deposits')
          .add({
        'amount': amount,
        'provider': selectedProvider,
        'mobileNumber': mobileNumber,
        'commission': commission,
        'finalAmount': finalAmount,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmDepositScreen(
            mobileNumber: mobileNumber,
            mobileProvider: selectedProvider,
            amount: amount,
            commission: commission,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving deposit: $e')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Deposit Mobile Money',
          style: TextStyle(color: Color(0xFF002733), fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
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

                    // Mobile number input for the selected provider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: TextField(
                        controller: activeNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: providerPlaceholder,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),
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
                    const SizedBox(height: 12),

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
                        onPressed: isSubmitting ? null : _handleContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38B000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
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
          ),
        ),
      ),
    );
  }
}
