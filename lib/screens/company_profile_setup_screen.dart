import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'procurement_preferences_screen.dart';

class CompanyProfileSetupScreen extends StatefulWidget {
  final String companyId; // Pass companyId from sign-up

  const CompanyProfileSetupScreen({super.key, required this.companyId});

  @override
  State<CompanyProfileSetupScreen> createState() => _CompanyProfileSetupScreenState();
}

class _CompanyProfileSetupScreenState extends State<CompanyProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController procurementOfficerController = TextEditingController();

  String selectedCompanyType = '';
  final List<String> companyTypes = ['Plastic Buyer', 'Recycler', 'Exporter', 'Manufacturer'];

  File? _companyLogo;
  bool _isLoading = false;

  // Image picker logic
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);

    if (picked != null) {
      setState(() {
        _companyLogo = File(picked.path);
      });
    }
  }

  Future<String?> _uploadLogoAndGetUrl(String companyId) async {
    if (_companyLogo == null) return null;
    final ref = FirebaseStorage.instance.ref().child('company_logos').child('$companyId.jpg');
    await ref.putFile(_companyLogo!);
    return await ref.getDownloadURL();
  }

  Future<void> _saveCompanyProfile() async {
    setState(() => _isLoading = true);
    final uid = widget.companyId;

    // Upload logo and get URL
    String? logoUrl;
    if (_companyLogo != null) {
      logoUrl = await _uploadLogoAndGetUrl(uid);
    }

    // Save to Firestore
    final companyData = {
      'companyName': companyNameController.text.trim(),
      'procurementOfficer': procurementOfficerController.text.trim(),
      'companyType': selectedCompanyType,
      'logoUrl': logoUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'uid': uid,
    };

    await FirebaseFirestore.instance.collection('companies').doc(uid).set(companyData, SetOptions(merge: true));
    setState(() => _isLoading = false);
  }

  void _onNextPressed() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && _companyLogo != null) {
      try {
        await _saveCompanyProfile();

        // Go to Procurement Preferences
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProcurementPreferencesScreen(companyId: '',)),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to complete signup: $e'), backgroundColor: Colors.red),
        );
      }
    } else if (_companyLogo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a company logo!'), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  void dispose() {
    companyNameController.dispose();
    procurementOfficerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: _companyLogo != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_companyLogo!, height: 100, width: 100, fit: BoxFit.cover),
                      )
                          : GestureDetector(
                        onTap: _pickImage,
                        child: Image.asset(
                          'assets/images/briefcase_illustration.png',
                          height: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_rounded, color: Colors.grey[700], size: 28),
                          const SizedBox(width: 8),
                          Text(
                            _companyLogo == null ? 'Upload Company Logo' : 'Change Logo',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Set Up Company Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF002733),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your company’s identity details below',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: companyNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Enter company name';
                        if (value.length < 2) return 'Enter a valid company name';
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Company Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedCompanyType.isNotEmpty ? selectedCompanyType : null,
                      items: companyTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedCompanyType = value ?? '');
                      },
                      validator: (value) => value == null || value.isEmpty ? 'Choose company type' : null,
                      decoration: const InputDecoration(
                        hintText: 'Choose type',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: procurementOfficerController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Enter procurement officer name';
                        if (value.length < 2) return 'Enter a valid name';
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Procurement Officer Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38B000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'Next',
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
          ],
        ),
      ),
    );
  }
}
