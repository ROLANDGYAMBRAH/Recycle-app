import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'business_info_screen.dart';

class CompounderSignUpScreen extends StatefulWidget {
  const CompounderSignUpScreen({super.key});

  @override
  State<CompounderSignUpScreen> createState() => _CompounderSignUpScreenState();
}

class _CompounderSignUpScreenState extends State<CompounderSignUpScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _phoneCtr  = TextEditingController();
  final _passCtr   = TextEditingController();
  final _confirmCtr = TextEditingController();
  bool  _agreed    = false;
  bool  _isLoading = false;

  InputDecoration get _decoration => InputDecoration(
    hintStyle: const TextStyle(fontSize: 16, color: Colors.black87),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  );

  @override
  void dispose() {
    _phoneCtr.dispose();
    _passCtr.dispose();
    _confirmCtr.dispose();
    super.dispose();
  }

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

(…shortened for display, use your full T&C content here…)

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

  // Convert phone (e.g., 501234567) to a synthetic email
  String _syntheticEmail(String phone) {
    return '+233$phone@eco.com';
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate() || !_agreed) return;

    final phone = _phoneCtr.text.trim();
    final password = _passCtr.text.trim();
    final email = _syntheticEmail(phone);

    setState(() => _isLoading = true);

    try {
      // 1. Create user in Firebase Auth
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = cred.user!.uid;

      // 2. Save to Firestore under users/UID (one-to-one with Auth)
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'phone': phone,
        'role' : 'compounder',
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() => _isLoading = false);

      // 3. Proceed to Business Info screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BusinessInfoScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Could not sign up')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving info: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                // ── Static store icon (no picker) ────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.asset(
                    'assets/images/compounder_store_icon.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 180,
                      height: 180,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.store, size: 80),
                    ),
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
                  'Create an account to start\ncollecting and trading recyclables',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                ),
                const SizedBox(height: 28),

                // ── Phone field ───────────────────────────────────────────────
                TextFormField(
                  controller: _phoneCtr,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter phone' :
                  (v.length != 9 && v.length != 10) ? 'Phone must be 9-10 digits' : null,
                  decoration: _decoration.copyWith(
                    hintText: 'Phone Number',
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/ghana_flag.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.flag_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('+233', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Password fields ───────────────────────────────────────────
                TextFormField(
                  controller: _passCtr,
                  obscureText: true,
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter password' :
                  (v.length < 8) ? 'Password must be at least 8 characters' : null,
                  decoration: _decoration.copyWith(hintText: 'Create Password'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmCtr,
                  obscureText: true,
                  validator: (v) =>
                  (v != _passCtr.text) ? 'Passwords do not match' : null,
                  decoration: _decoration.copyWith(hintText: 'Confirm Password'),
                ),
                const SizedBox(height: 12),

                // ── Terms checkbox ───────────────────────────────────────────
                Row(
                  children: [
                    Checkbox(
                      value: _agreed,
                      activeColor: Colors.blue,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                    ),
                    const Text('I agree to the '),
                    GestureDetector(
                      onTap: _showTermsDialog,
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

                // ── Continue button ───────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _agreed &&
                        !_isLoading &&
                        _formKey.currentState != null &&
                        _formKey.currentState!.validate()
                        ? _handleSignUp
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3CBD1D),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
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
                GestureDetector(
                  onTap: () {
                    // TODO: navigate to sign-in
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
