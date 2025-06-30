import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'company_profile_setup_screen.dart'; // Adjust path as needed

class CompanySignUpScreen extends StatefulWidget {
  const CompanySignUpScreen({super.key});

  @override
  State<CompanySignUpScreen> createState() => _CompanySignUpScreenState();
}

class _CompanySignUpScreenState extends State<CompanySignUpScreen> {
  final TextEditingController identifierController = TextEditingController(); // email or phone
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool agreedToTerms = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter email or phone number';
    }
    // Basic email or phone validation
    final emailReg = RegExp(r"^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$");
    final phoneReg = RegExp(r"^(?:\+233|0)[0-9]{9}$");
    if (!emailReg.hasMatch(value.trim()) && !phoneReg.hasMatch(value.trim())) {
      return 'Enter valid email or Ghana phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String _hashPassword(String password) {
    // SHA256 hash
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: SingleChildScrollView(
          child: Text(
            termsAndConditions,
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

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate() || !agreedToTerms) return;

    final identifierRaw = identifierController.text.trim();
    final passwordRaw = passwordController.text.trim();
    final hashedPassword = _hashPassword(passwordRaw);

    setState(() => isLoading = true);

    try {
      // Save to Firestore under /companies/[identifier]
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(identifierRaw)
          .set({
        'identifier': identifierRaw,
        'signupRaw': identifierRaw,
        'password': hashedPassword,
        'role': 'company',
        'createdAt': FieldValue.serverTimestamp(),
        'signupMethod': 'manual',
      });

      setState(() => isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompanyProfileSetupScreen(companyId: identifierRaw),
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving info: $e')),
      );
    }
  }

  /// Google Sign-In Logic
  Future<void> _handleGoogleSignUp() async {
    setState(() => isLoading = true);
    try {
      // Step 1: Start Google sign-in
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => isLoading = false);
        return; // cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 2: Authenticate with Firebase
      UserCredential userCred =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCred.user;

      if (user == null) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google authentication failed')),
        );
        return;
      }

      // Step 3: Save to Firestore
      final docRef = FirebaseFirestore.instance.collection('companies').doc(user.email);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        // New user: add to Firestore
        await docRef.set({
          'identifier': user.email,
          'signupRaw': user.email,
          'role': 'company',
          'createdAt': FieldValue.serverTimestamp(),
          'displayName': user.displayName,
          'signupMethod': 'google',
          'photoUrl': user.photoURL,
        });
      }

      setState(() => isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompanyProfileSetupScreen(companyId: user.email ?? ''),
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign up failed: $e')),
      );
    }
  }

  static const String termsAndConditions = '''
Welcome to Eco Trade!

Effective Date: July 2025

By signing up, you agree to:
• Provide accurate information.
• Use this app lawfully and respectfully.
• Keep your login details secure.
• Allow us to store your information securely.
• Accept that your account may be suspended for misuse.

Your privacy matters. Your data will never be shared without your consent. Full terms available at www.ecotrade.com/terms

Thank you for helping build a cleaner, greener Ghana!
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/company_illustration.png',
                    height: 140,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sign Up as a Company',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002733),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create a secure account to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 28),

                TextFormField(
                  controller: identifierController,
                  validator: _validateIdentifier,
                  decoration: const InputDecoration(
                    hintText: 'Company email or Ghana phone number',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    hintText: 'Create password',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  validator: _validateConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: isLoading ? null : _handleGoogleSignUp,
                  icon: Image.asset(
                    'assets/images/google_icon.png',
                    height: 18,
                  ),
                  label: const Text(
                    'Sign up with Google',
                    style: TextStyle(color: Colors.black87),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(
                      value: agreedToTerms,
                      onChanged: (val) {
                        setState(() {
                          agreedToTerms = val ?? false;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    const Text('I agree to the '),
                    GestureDetector(
                      onTap: _showTermsDialog,
                      child: const Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF002733),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate() && agreedToTerms) {
                        _handleSignUp();
                      } else if (!agreedToTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please agree to the Terms & Conditions.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38B000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
