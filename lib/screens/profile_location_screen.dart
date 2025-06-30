import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class ProfileLocationScreen extends StatefulWidget {
  const ProfileLocationScreen({Key? key}) : super(key: key);

  @override
  State<ProfileLocationScreen> createState() => _ProfileLocationScreenState();
}

class _ProfileLocationScreenState extends State<ProfileLocationScreen> {
  final _firstName = TextEditingController();
  final _lastName  = TextEditingController();

  String? selectedArea;
  File?   selectedImage;
  final   _picker = ImagePicker();

  bool isLoadingLocation = false;
  bool isSavingProfile   = false;

  final areas = ['Accra', 'Madina', 'Adenta', 'Tesano', 'Abeka', 'Tema', 'Kasoa'];

  bool _isValidName(String name) =>
      RegExp(r'^[A-Za-zÀ-ÿ\- ]{2,30}$').hasMatch(name.trim());

  String _toTitle(String s) =>
      s.trim().isEmpty ? '' : s.trim()[0].toUpperCase() + s.trim().substring(1).toLowerCase();

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 80,
    );
    if (img == null) return;

    final bytes = await File(img.path).length();
    if (bytes > 5 * 1024 * 1024) {
      _err('Photo must be under 5 MB');
      return;
    }
    setState(() => selectedImage = File(img.path));
  }

  Future<void> _getCurrentLocation() async {
    setState(() => isLoadingLocation = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services disabled';
      }

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        _err('Location permission permanently denied. Enable it in Settings.');
        await openAppSettings();
        return;
      }
      if (perm != LocationPermission.whileInUse && perm != LocationPermission.always) {
        throw 'Location permission denied';
      }

      final pos   = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (marks.isNotEmpty) {
        final p = marks.first;
        setState(() => selectedArea = '${p.locality}, ${p.administrativeArea}');
      }
    } catch (e) {
      _err('Error getting location: $e');
    } finally {
      setState(() => isLoadingLocation = false);
    }
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) { _err('No signed-in user'); return; }

    if (!_isValidName(_firstName.text)) { _err('Enter a valid first name.'); return; }
    if (!_isValidName(_lastName.text))  { _err('Enter a valid last name.');  return; }
    if (selectedArea == null || !areas.contains(selectedArea)) {
      _err('Please select a service area.'); return;
    }
    if (selectedImage == null) {
      _err('Please upload a profile photo.'); return;
    }

    setState(() => isSavingProfile = true);

    try {
      final storage = FirebaseStorage.instance;
      print('FIREBASE BUCKET: ${storage.bucket}');

      final ext      = p.extension(selectedImage!.path).toLowerCase();
      final bytes    = await selectedImage!.readAsBytes();
      final mimeType = lookupMimeType(selectedImage!.path, headerBytes: bytes) ?? 'image/jpeg';
      final ref      = storage
          .ref()
          .child('profile_photos/$uid/avatar$ext');

      print('Uploading image… ext=$ext mime=$mimeType size=${bytes.length}');

      final uploadTask = ref.putData(
        bytes,
        SettableMetadata(contentType: mimeType),
      );

      final snapshot = await uploadTask;
      print('Upload completed. State: ${snapshot.state}');

      final photoUrl = await ref.getDownloadURL();
      print('Image uploaded. URL=$photoUrl');

      await FirebaseFirestore.instance.doc('users/$uid').set({
        'firstName'       : _toTitle(_firstName.text),
        'lastName'        : _toTitle(_lastName.text),
        'area'            : selectedArea,
        'profileImageUrl' : photoUrl,
      }, SetOptions(merge: true));

      if (!mounted) return;
      await Navigator.pushNamed(context, '/recycle_items');
      _resetForm();
    } catch (e, st) {
      print('Profile save error: $e\n$st');
      _err('Saving failed: $e');
    } finally {
      if (mounted) setState(() => isSavingProfile = false);
    }
  }

  void _resetForm() {
    _firstName.clear();
    _lastName.clear();
    setState(() {
      selectedArea  = null;
      selectedImage = null;
    });
  }

  void _err(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      // title: const Text('Profile Location', style: TextStyle(color: Colors.black)), // Optionally add a title
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 44),
            const Text('Profile Location',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11333D))),
            const SizedBox(height: 22),
            Image.asset('assets/images/profile_location.png',
                width: 90, height: 90),
            const SizedBox(height: 34),

            Align(alignment: Alignment.centerLeft, child: _label('Full Name')),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _textField(_firstName, 'First Name')),
              const SizedBox(width: 12),
              Expanded(child: _textField(_lastName , 'Last Name' )),
            ]),
            const SizedBox(height: 22),

            Align(alignment: Alignment.centerLeft, child: _label('Profile Photo')),
            const SizedBox(height: 10),
            GestureDetector(onTap: _pickImage, child: _photoUploadField()),
            if (selectedImage != null) ...[
              const SizedBox(height: 10),
              CircleAvatar(radius: 40, backgroundImage: FileImage(selectedImage!)),
            ],

            const SizedBox(height: 22),

            Align(alignment: Alignment.centerLeft, child: _label('Location')),
            const SizedBox(height: 8),
            _locationButton(),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedArea,
              hint: const Text('Select area'),
              items: areas
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
              onChanged: (v) => setState(() => selectedArea = v),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
              ),
            ),

            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isSavingProfile ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38B000),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: isSavingProfile
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Next',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    ),
  );

  Widget _label(String txt) => Text(txt,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

  Widget _textField(TextEditingController c, String hint) => TextField(
    controller: c,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9EA6AE)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
  );

  Widget _photoUploadField() => Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
    decoration: BoxDecoration(
      color: const Color(0xFFF3F9FF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(children: [
      const Icon(Icons.camera_alt_outlined, color: Color(0xFF2196F3), size: 28),
      const SizedBox(width: 12),
      Text(selectedImage != null ? 'Photo Selected' : 'Upload Photo',
          style: const TextStyle(
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.w600,
              fontSize: 17)),
      if (selectedImage != null) ...[
        const Spacer(),
        const Icon(Icons.check_circle, color: Colors.green, size: 20),
      ],
    ]),
  );

  Widget _locationButton() => GestureDetector(
    onTap: isLoadingLocation ? null : _getCurrentLocation,
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (isLoadingLocation)
        const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2)),
      if (isLoadingLocation) const SizedBox(width: 8),
      Text(
        isLoadingLocation ? 'Getting location…' : 'Use current location',
        style: const TextStyle(
            color: Color(0xFF1976D2),
            decoration: TextDecoration.underline,
            fontSize: 16),
      ),
    ]),
  );
}
