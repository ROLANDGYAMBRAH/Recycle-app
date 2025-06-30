import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'all_set_screen.dart'; // <-- Make sure this path matches your file!

class RecycleItemsScreen extends StatefulWidget {
  const RecycleItemsScreen({Key? key}) : super(key: key);

  @override
  State<RecycleItemsScreen> createState() => _RecycleItemsScreenState();
}

class _RecycleItemsScreenState extends State<RecycleItemsScreen> {
  List<String> selectedItems = [];
  String? selectedFrequency;
  bool isSubmitting = false;

  final List<String> recycleItems = [
    'Pure Water Rubbers',
    'Old Bowls & Buckets',
    'Plastic Bottles',
    'Pipes or Plumbing Plastic',
    'Glass Bottles',
    'Cardboard & Paper',
    'Cans',
    'Electronics',
    'Textiles & Clothing',
    'Metal Scraps',
  ];

  final List<String> frequencies = [
    'Daily',
    'Weekly',
    'Monthly',
    'Occasionally',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recycle Items',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header section with custom image
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'What Do You Usually Recycle?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11333D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose the items you often collect',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/items.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recycle items section
                  const Text(
                    'Select Items:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF11333D),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Items grid
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: recycleItems.map((item) {
                      final isSelected = selectedItems.contains(item);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedItems.remove(item);
                            } else {
                              selectedItems.add(item);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE8F5E8)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF38B000)
                                  : const Color(0xFFE0E0E0),
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF38B000)
                                  : const Color(0xFF666666),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Frequency section
                  const Text(
                    'How often do you recycle?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF11333D),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Frequency options
                  Column(
                    children: frequencies.map((frequency) {
                      final isSelected = selectedFrequency == frequency;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFrequency = frequency;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE8F5E8)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF38B000)
                                    : const Color(0xFFE0E0E0),
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF38B000)
                                          : const Color(0xFFCCCCCC),
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? const Color(0xFF38B000)
                                        : Colors.white,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  frequency,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF38B000)
                                        : const Color(0xFF666666),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 40),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _canContinue() ? () {
                        _showSelectionSummary();
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38B000),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canContinue() {
    return selectedItems.isNotEmpty && selectedFrequency != null;
  }

  void _showSelectionSummary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Recycling Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...selectedItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• $item'),
            )),
            const SizedBox(height: 16),
            const Text(
              'Frequency:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('$selectedFrequency'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: isSubmitting ? null : () {
              print('=== CONFIRM BUTTON PRESSED ===');
              Navigator.pop(context);
              _saveDataAndNavigate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38B000),
            ),
            child: isSubmitting
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text(
              'Confirm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDataAndNavigate() async {
    print('=== SAVE DATA AND NAVIGATE CALLED ===');
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print('UID: $uid');

    if (uid == null) {
      print('ERROR: User not authenticated!');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
      return;
    }

    print('Selected Items: $selectedItems');
    print('Selected Frequency: $selectedFrequency');

    setState(() => isSubmitting = true);

    try {
      // Create a map where selected items are set to true
      final Map<String, bool> materialMap = {
        for (String item in selectedItems) item: true
      };

      print('Material map to save: $materialMap');
      print('=== STARTING FIRESTORE WRITE ===');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        'materials': materialMap,
        'recycleFrequency': selectedFrequency,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('=== FIRESTORE WRITE SUCCESSFUL ===');

      if (!mounted) return;

      print('=== NAVIGATING TO ALL SET SCREEN ===');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AllSetScreen()),
      );

    } on FirebaseException catch (e) {
      print('=== FIREBASE EXCEPTION ===');
      print('Firebase Error: ${e.code} - ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firebase error: ${e.message}')),
        );
      }
    } catch (e) {
      print('=== GENERAL EXCEPTION ===');
      print('Error saving data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }
}