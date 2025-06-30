import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'company_allset_screen.dart'; // Make sure this import matches your file/class name

class ProcurementPreferencesScreen extends StatefulWidget {
  final String companyId;

  const ProcurementPreferencesScreen({super.key, required this.companyId});

  @override
  State<ProcurementPreferencesScreen> createState() => _ProcurementPreferencesScreenState();
}

class _ProcurementPreferencesScreenState extends State<ProcurementPreferencesScreen> {
  String selectedLocation = 'Accra';
  final List<String> locations = ['Accra', 'Kumasi', 'Takoradi', 'Tam-ale'];
  final List<String> allMaterials = [
    'Plastic Bottles',
    'Scrap Metals',
    'Cartons &',
    'Beer Glass Bottles',
    'Aluminum Cans',
    'Used Cardboard',
    'HDPE Buckets',
    'Glass Jars'
  ];

  final Set<String> selectedMaterials = {'Plastic Bottles'};
  final TextEditingController quantityController = TextEditingController();
  bool requestVerification = false;

  bool _isLoading = false;

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  Future<void> _savePreferences() async {
    setState(() => _isLoading = true);
    try {
      final location = selectedLocation; // No null check needed!
      final materials = selectedMaterials.isNotEmpty ? selectedMaterials.toList() : [];
      final quantity = quantityController.text.trim();
      final safeQuantity = quantity.isNotEmpty ? quantity : '0';

      await FirebaseFirestore.instance.collection('companies').doc(widget.companyId).set({
        'location': location,
        'materialsNeeded': materials,
        'quantityPerPurchase': safeQuantity,
        'requestVerification': requestVerification,
      }, SetOptions(merge: true));

      setState(() => _isLoading = false);

      // Navigate to CompanyAllSetScreen after saving
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CompanyAllSetScreen()),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _onCompleteSignup() {
    FocusScope.of(context).unfocus();

    final quantity = quantityController.text.trim();

    if (selectedMaterials.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one material.')),
      );
      return;
    }
    if (quantity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a quantity.')),
      );
      return;
    }
    if (double.tryParse(quantity) == null || double.parse(quantity) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid positive quantity (e.g. 1000).')),
      );
      return;
    }

    _savePreferences();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/checklist_illustration.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Set Your Procurement\nPreferences',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002733),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Where is your company based?',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    items: locations.map((loc) {
                      return DropdownMenuItem(
                        value: loc,
                        child: Text(loc),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value ?? 'Accra';
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Materials needed',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: allMaterials.map((material) {
                      final isSelected = selectedMaterials.contains(material);
                      return ChoiceChip(
                        label: Text(material),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            if (isSelected) {
                              selectedMaterials.remove(material);
                            } else {
                              selectedMaterials.add(material);
                            }
                          });
                        },
                        selectedColor: const Color(0xFFDDD6FF),
                        backgroundColor: const Color(0xFFEFF2F5),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quantity per purchase',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter typical quantity (e.g. 1000 KG)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: requestVerification,
                    activeColor: Colors.green,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Request a verification badge'),
                    onChanged: (val) {
                      setState(() {
                        requestVerification = val ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onCompleteSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38B000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
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
          ],
        ),
      ),
    );
  }
}
