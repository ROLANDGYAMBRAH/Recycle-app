import 'package:flutter/material.dart';

class MaterialTypeFilterSheet extends StatefulWidget {
  const MaterialTypeFilterSheet({super.key});

  @override
  State<MaterialTypeFilterSheet> createState() => _MaterialTypeFilterSheetState();
}

class _MaterialTypeFilterSheetState extends State<MaterialTypeFilterSheet> {
  final List<String> allMaterials = [
    'Pure Water Rubber',
    'Plastic Bottle',
    'Plastic Keg',
    'Plastic Crate',
    'Jerrycan',
    'Soft Plastics',
  ];

  final Set<String> selectedMaterials = {'Pure Water Rubber', 'Plastic Bottle'};

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text('Choose Material Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: allMaterials.length,
                itemBuilder: (_, index) {
                  final material = allMaterials[index];
                  return CheckboxListTile(
                    title: Text(material),
                    value: selectedMaterials.contains(material),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedMaterials.add(material);
                        } else {
                          selectedMaterials.remove(material);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedMaterials.toList());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
