import 'package:flutter/material.dart';

class ProcurementPreferencesScreen extends StatefulWidget {
  const ProcurementPreferencesScreen({super.key});

  @override
  State<ProcurementPreferencesScreen> createState() => _ProcurementPreferencesScreenState();
}

class _ProcurementPreferencesScreenState extends State<ProcurementPreferencesScreen> {
  String selectedLocation = 'Accra';
  final List<String> locations = ['Accra', 'Kumasi', 'Takoradi', 'Tamale'];
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

  @override
  void dispose() {
    quantityController.dispose();
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
              // Top image
              Center(
                child: Image.asset(
                  'assets/images/checklist_illustration.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 24),

              // Title
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

              // Location Dropdown
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
                    selectedLocation = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Materials needed
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

              // Quantity
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

              // Verification checkbox
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

              // Complete Signup Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Submit logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
