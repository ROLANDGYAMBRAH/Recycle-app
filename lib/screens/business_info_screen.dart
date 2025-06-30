import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eco_trade_final/screens/materials_collection_screen.dart'; // Correct import path
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  String selectedType = 'Individual';
  String? selectedArea;
  File? profileImage;
  File? coverImage;
  bool isSaving = false;

  final List<String> types = ['Individual', 'Group', 'Company-Linked'];
  final List<String> areas = ['Accra', 'Tema', 'Madina', 'Kasoa'];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _businessNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isProfile) async {
    final img = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 80,
    );
    if (img == null) return;

    final bytes = await File(img.path).length();
    if (bytes > 5 * 1024 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo must be under 5 MB')),
      );
      return;
    }
    setState(() {
      if (isProfile) {
        profileImage = File(img.path);
      } else {
        coverImage = File(img.path);
      }
    });
  }

  Future<String> _uploadImage(File image, String storagePath) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ext = p.extension(image.path).toLowerCase();
    final bytes = await image.readAsBytes();
    final mimeType = lookupMimeType(image.path, headerBytes: bytes) ?? 'image/jpeg';
    final ref = FirebaseStorage.instance.ref().child('$storagePath/$uid$ext');
    final uploadTask = ref.putData(bytes, SettableMetadata(contentType: mimeType));
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _saveBusinessInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not authenticated')));
      return;
    }

    final name = _businessNameController.text.trim();

    if (name.isEmpty || selectedArea == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter business name and select area')),
      );
      return;
    }
    if (profileImage == null || coverImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload both profile and cover photos')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      // Upload profile and cover images
      final profileUrl = await _uploadImage(profileImage!, 'compounders/profile_photo');
      final coverUrl = await _uploadImage(coverImage!, 'compounders/cover_photo');

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'businessName'    : name,
        'businessType'    : selectedType,
        'businessArea'    : selectedArea,
        'profileImageUrl' : profileUrl,
        'coverImageUrl'   : coverUrl,
      }, SetOptions(merge: true));

      setState(() => isSaving = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MaterialsCollectionScreen()),
      );
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save info: $e')),
      );
    }
  }

  Widget _photoPicker({
    required String label,
    required bool isProfile,
    required File? image,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickImage(isProfile),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.camera_alt_outlined, color: Colors.blue),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    image != null ? 'Photo Selected' : 'Upload Photo',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (image != null) ...[
                  const SizedBox(width: 4),
                  CircleAvatar(
                    backgroundImage: FileImage(image),
                    radius: 14, // Smaller avatar
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
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
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/business_illustration.png',
                      height: 140,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'Tell Us About Your\nBusiness',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF002733),
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'This info will help collectors\nfind and trust you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Business Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _businessNameController,
                    decoration: InputDecoration(
                      hintText: 'Business Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    children: types.map((type) {
                      final isSelected = type == selectedType;
                      return ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedType = type;
                          });
                        },
                        selectedColor: const Color(0xFF38B000),
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _photoPicker(
                          label: 'Profile Photo',
                          isProfile: true,
                          image: profileImage,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _photoPicker(
                          label: 'Cover Photo',
                          isProfile: false,
                          image: coverImage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Choose your base location',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement current location picker if needed
                          },
                          child: const Text(
                            'Use current location',
                            style: TextStyle(
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: selectedArea,
                          hint: const Text('Select area'),
                          items: areas.map((area) {
                            return DropdownMenuItem<String>(
                              value: area,
                              child: Text(area),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedArea = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _saveBusinessInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38B000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Next',
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
            // Slide Up Hint
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Column(
                children: const [
                  Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                  SizedBox(height: 4),
                  Text(
                    'Slide up to continue',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
