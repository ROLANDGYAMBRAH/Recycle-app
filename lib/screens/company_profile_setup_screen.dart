import 'package:flutter/material.dart';
import 'company_allset_screen.dart'; // ✅ Ensure this file is created and available

class CompanyProfileSetupScreen extends StatefulWidget {
  const CompanyProfileSetupScreen({super.key});

  @override
  State<CompanyProfileSetupScreen> createState() => _CompanyProfileSetupScreenState();
}

class _CompanyProfileSetupScreenState extends State<CompanyProfileSetupScreen> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController procurementOfficerController = TextEditingController();

  String selectedCompanyType = '';
  final List<String> companyTypes = ['Plastic Buyer', 'Recycler', 'Exporter', 'Manufacturer'];

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/briefcase_illustration.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 24),
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

              TextField(
                controller: companyNameController,
                decoration: const InputDecoration(
                  hintText: 'Company Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt, size: 32, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'Company logo',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedCompanyType.isNotEmpty ? selectedCompanyType : null,
                items: companyTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCompanyType = value ?? '';
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Choose type',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: procurementOfficerController,
                decoration: const InputDecoration(
                  hintText: 'Procurement Officer Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CompanyAllSetScreen(), // ✅ Final destination
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Complete Signup',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
