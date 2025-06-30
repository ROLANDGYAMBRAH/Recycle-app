import 'package:flutter/material.dart';
import 'package:eco_trade_final/screens/business_info_screen.dart';

class CompounderSignUpScreen extends StatefulWidget {
  const CompounderSignUpScreen({super.key});

  @override
  State<CompounderSignUpScreen> createState() => _CompounderSignUpScreenState();
}

class _CompounderSignUpScreenState extends State<CompounderSignUpScreen> {
  bool agreed = false; // User must agree manually

  final InputDecoration _inputDecoration = InputDecoration(
    hintStyle: TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.w400,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/images/compounder_store_icon.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign Up as a\nCompounder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D1A26),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Create an account to start\ncollecting and trading\nrecyclables',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                // Phone Number Field
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration.copyWith(
                    hintText: 'Phone Number',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/ghana_flag.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '+233',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  ),
                ),

                const SizedBox(height: 12),
                TextFormField(
                  obscureText: true,
                  decoration: _inputDecoration.copyWith(hintText: 'Create Password'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  obscureText: true,
                  decoration: _inputDecoration.copyWith(hintText: 'Confirm password'),
                ),
                const SizedBox(height: 12),

                // Terms & Conditions Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: agreed,
                      onChanged: (value) {
                        setState(() {
                          agreed = value ?? false;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    const Text('I agree to the '),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Terms page
                      },
                      child: const Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: agreed
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BusinessInfoScreen(),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3CBD1D),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      disabledBackgroundColor: Colors.grey.shade300,
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
                GestureDetector(
                  onTap: () {
                    // Navigate to Sign In
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
