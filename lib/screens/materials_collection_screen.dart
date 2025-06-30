import 'package:eco_trade_final/screens/topup_wallet_screen.dart';
import 'package:flutter/material.dart';


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

  void handleSubmit() {
    // You can process the selected materials and prices here
    // Then navigate to the top-up screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TopUpWalletScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                'Business Name',
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
                            decoration: InputDecoration(
                              prefixText: 'GH₵ ',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue.shade200),
                              ),
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
                  onPressed: handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
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
