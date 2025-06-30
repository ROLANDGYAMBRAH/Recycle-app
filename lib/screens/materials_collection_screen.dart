import 'package:eco_trade_final/screens/topup_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialsCollectionScreen extends StatefulWidget {
  const MaterialsCollectionScreen({super.key});

  @override
  State<MaterialsCollectionScreen> createState() => _MaterialsCollectionScreenState();
}

class _MaterialsCollectionScreenState extends State<MaterialsCollectionScreen> {
  final List<String> materials = [
    'Pure Water Rubbers',
    'Plastic Bottles',
    'Scrap Metals',
    'Pipes',
    'Old Bowls & Buckets',
    'Paper & Cardboard',
  ];

  final Map<String, bool> selectedMaterials = {};
  final Map<String, TextEditingController> priceControllers = {};
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    for (final item in materials) {
      selectedMaterials[item] = false;
      priceControllers[item] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in priceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> handleSubmit() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')));
      return;
    }

    // Only selected materials with a valid price
    final Map<String, dynamic> data = {};
    bool hasAtLeastOne = false;

    for (final material in materials) {
      if (selectedMaterials[material] == true) {
        final priceText = priceControllers[material]?.text.trim() ?? '';
        if (priceText.isEmpty) continue;
        double? price = double.tryParse(priceText);
        if (price == null || price <= 0) continue;
        data[material] = price;
        hasAtLeastOne = true;
      }
    }

    if (!hasAtLeastOne) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one material and enter a valid price.')));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // Save to Firestore: /compounders/UID/materials
      await FirebaseFirestore.instance
          .collection('compounders')
          .doc(uid)
          .set({
        'materials': data,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Materials saved!')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TopUpWalletScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Materials Collection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/materials_illustration.png',
                  height: 140,
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'What Materials Do You Collect?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002733),
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Select all materials you accept\nand your payment range',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Materials',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: materials.map((material) {
                  final isSelected = selectedMaterials[material] ?? false;
                  return ChoiceChip(
                    label: Text(material),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedMaterials[material] = selected;
                      });
                    },
                    selectedColor: const Color(0xFFD9F5CB),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF38B000) : Colors.blue,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              const Text(
                'Your Typical Price per KG',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: materials.map((material) {
                  final enabled = selectedMaterials[material] ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            height: 48,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              material,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: priceControllers[material],
                            keyboardType: TextInputType.number,
                            enabled: enabled,
                            decoration: InputDecoration(
                              prefixText: 'GH₵ ',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue.shade200),
                              ),
                              hintText: enabled ? '0.00' : '',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
