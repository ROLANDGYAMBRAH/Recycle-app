import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eco_trade_final/utils/phone_utils.dart';
import 'collector_signing_screen.dart';

class CollectorSignUpScreen extends StatefulWidget {
  const CollectorSignUpScreen({super.key});

  @override
  State<CollectorSignUpScreen> createState() => _CollectorSignUpScreenState();
}

class _CollectorSignUpScreenState extends State<CollectorSignUpScreen> {
  final TextEditingController phoneController    = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController  = TextEditingController();

  bool agreed      = false;
  bool isLoading   = false;
  bool _obscurePwd = true;
  bool _obscureCnf = true;

  final _auth      = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  // ───────────────────────── SIGN-UP ─────────────────────────
  Future<void> _handleSignUp() async {
    final phone    = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirm  = confirmController.text.trim();

    // ---------- VALIDATION ----------
    if (phone.isEmpty || password.isEmpty || confirm.isEmpty)  { _err('All fields are required'); return; }
    if (phone.length != 10)                                    { _err('Phone number must be 10 digits'); return; }
    if (!agreed)                                               { _err('Please accept the Terms & Conditions'); return; }
    if (password.length < 8)                                   { _err('Password must be at least 8 characters'); return; }
    if (password != confirm)                                   { _err('Passwords do not match'); return; }

    final email = phoneToEmail(phone);        // helper strips “0” or “233” automatically
    setState(() => isLoading = true);

    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.doc('users/${cred.user!.uid}').set({
        'phone'     : phone,
        'email'     : email,
        'role'      : 'collector',
        'createdAt' : FieldValue.serverTimestamp(),
      });

      // clear form
      phoneController.clear();
      passwordController.clear();
      confirmController.clear();
      setState(() => agreed = false);

      setState(() => isLoading = false);
      Navigator.pushReplacementNamed(context, '/signup/profile');   // remove Sign-Up from back-stack
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      _err(e.message ?? 'Sign-up failed');
    } catch (e) {
      setState(() => isLoading = false);
      _err('Unexpected error: $e');
    }
  }

  void _err(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: SingleChildScrollView(
          child: Text(
            '''
Effective Date: July 2025

Welcome to Eco Trade! These Terms & Conditions (“Terms”) govern your access to and use of the Eco Trade mobile application (“App”) and related services (“Services”). By creating an account, accessing, or using the App, you agree to these Terms.

1. Account Registration & Eligibility
• You must be at least 18 years old or have the consent of a legal guardian to use Eco Trade.
• You agree to provide accurate, current, and complete information during sign-up and keep your information updated.
• You are responsible for maintaining the confidentiality of your account and password and for all activities that occur under your account.

2. Use of Services
• Eco Trade connects Collectors, Compounders, and Companies to facilitate recycling activities and environmental sustainability.
• You agree to use the App for lawful purposes only.
• Do not share your account or allow others to access your account.
• You are responsible for all materials collected, submitted, or delivered through your account.

3. User Responsibilities
• Respect all applicable laws and community guidelines while using the App.
• Do not engage in fraudulent, abusive, or harmful behavior.
• Do not attempt to hack, decompile, or reverse-engineer any part of the App or Services.
• Do not upload or distribute viruses or harmful code.

4. Privacy & Data
• By using Eco Trade, you consent to the collection and use of your data as described in our Privacy Policy.
• Your personal information, collection history, and profile data may be used to provide, improve, and personalize the Services.
• We do not sell your personal information to third parties.

5. Payments & Rewards
• If you participate in reward programs or cash-outs, ensure your payment details are accurate and up-to-date.
• Eco Trade is not responsible for delays or failures in payment caused by incorrect user information or third-party services (e.g., mobile money providers).
• All transactions and balances are subject to verification.

6. Account Suspension & Termination
• We may suspend or terminate your account at any time for violations of these Terms or suspected fraud.
• You may close your account at any time by contacting support.
• Upon termination, you lose access to your account, and any unredeemed rewards may be forfeited.

7. Intellectual Property
• All content and trademarks on the App are the property of Eco Trade or its partners.
• You may not copy, reproduce, distribute, or create derivative works from any part of the App without our written permission.

8. Limitation of Liability
• Eco Trade is provided “as is” and without warranties of any kind.
• We are not liable for any loss or damages resulting from your use of the App, including loss of data, rewards, or unauthorized account access.

9. Modifications to Terms
• We may update these Terms at any time. Continued use of the App after changes means you accept the new Terms.
• Material changes will be notified to users through the App or by email.

10. Contact Us
For questions or support, contact us at:
Email: support@ecotradeapp.com

Thank you for being a part of the Eco Trade community and helping to make our environment cleaner and more sustainable!
            ''',
            style: const TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── UI ─────────────────────────
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/collector.png', height: 140)),
            const SizedBox(height: 20),
            const Text('Sign Up as a\nCollector',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF002733))),
            const SizedBox(height: 10),
            const Text('Create your account to start\nrecycling and earning',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF5A6B7B))),
            const SizedBox(height: 30),

            // PHONE
            _box(
              Row(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset('assets/images/ghana_flag.png', width: 22, height: 15),
                      ),
                      const SizedBox(width: 6),
                      const Text('+233', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10), // ← 10-digit limit
                      ],
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Phone Number'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // PASSWORD
            _box(
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscurePwd,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Create Password'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_obscurePwd ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePwd = !_obscurePwd),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // CONFIRM PASSWORD
            _box(
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: confirmController,
                      obscureText: _obscureCnf,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Confirm Password'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_obscureCnf ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureCnf = !_obscureCnf),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // TERMS (with clickable T&C)
            Row(
              children: [
                Checkbox(value: agreed, activeColor: Colors.blue, onChanged: (v) => setState(() => agreed = v!)),
                const Text('I agree to the '),
                GestureDetector(
                  onTap: _showTermsDialog,
                  child: const Text('Terms & Conditions',
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // CONTINUE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF45B200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 22),

            // SIGN-IN LINK (pushReplacement keeps Sign-Up off stack)
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CollectorSigningScreen()),
              ),
              child: const Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: 'Sign in',
                      style: TextStyle(color: Color(0xFF45B200), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // simple border box
  Widget _box(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}
