// File: lib/screens/collector_home_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ❌ remove: import 'search_screen.dart';
import 'material_category_screen.dart';
import 'material_list_screen.dart';
// ✅ add this:
import 'search_results_screen.dart';

class CollectorHomeScreen extends StatefulWidget {
  const CollectorHomeScreen({super.key});

  @override
  State<CollectorHomeScreen> createState() => _CollectorHomeScreenState();
}

class _CollectorHomeScreenState extends State<CollectorHomeScreen> {
  File? _selectedImage;
  String? _firstName;
  String? _profileImageUrl;

  int _navIndex = 0; // 0=Home, 1=Search, 2=Chats, 3=Learn, 4=Profile

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _firstName = data['firstName'] ?? '';
          _profileImageUrl = data['profileImageUrl'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  // ✅ open the results screen (not SearchScreen)
  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchResultsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomNavBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            _logoCentered(),
            const SizedBox(height: 20),
            _topBar(),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _openSearch, // tap search bar → SearchResultsScreen
              child: _searchBar(),
            ),
            const SizedBox(height: 22),
            _statsSection(),
            const SizedBox(height: 26),
            _sectionHeader('Materials', 'view all'),
            const SizedBox(height: 14),
            _materialRow(),
            const SizedBox(height: 26),
            _sectionHeader('🔥 Hot Deals Near You', 'view all'),
            const SizedBox(height: 12),
            _hotDealCard(),
            const SizedBox(height: 28),
            _sectionHeader('💡 How to Earn', 'Learn more >'),
            const SizedBox(height: 14),
            _howToEarnRow(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _logoCentered() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 24),
        Image.asset('assets/images/recycle_logo.png', height: 44, width: 44),
        GestureDetector(
          onTap: _openSearch, // top-right icon → SearchResultsScreen
          child: const Icon(Icons.search, size: 26),
        ),
      ],
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 26,
            backgroundImage: _selectedImage != null
                ? FileImage(_selectedImage!)
                : _profileImageUrl != null
                ? NetworkImage(_profileImageUrl!)
                : const AssetImage('assets/images/profile.png') as ImageProvider,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Hello ${_firstName ?? ''},',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF38B000),
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Text('What do you want to recycle?', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _statsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard('EARNED', 'GHS 152.00', '+15% this week', Icons.show_chart),
        _statCard('KG COLLECTED', '72 kg', '', Icons.scale),
        _statCard('CO2 SAVED', '500 g', '', Icons.eco),
      ],
    );
  }

  Widget _statCard(String label, String value, String subtext, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.green, size: 20),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (subtext.isNotEmpty)
              Text(subtext, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        GestureDetector(
          onTap: () {
            if (title == 'Materials') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MaterialCategoryScreen()),
              );
            }
          },
          child: Text(action, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ),
      ],
    );
  }

  Widget _materialRow() {
    return Row(
      children: [
        Expanded(child: _materialCard('Plastic', 'assets/images/plastic.png')),
        const SizedBox(width: 14),
        Expanded(child: _materialCard('Glass', 'assets/images/glass.png')),
        const SizedBox(width: 14),
        Expanded(child: _materialCard('Metal', 'assets/images/metal.png')),
      ],
    );
  }

  Widget _materialCard(String label, String assetPath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MaterialListScreen(materialName: label)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(assetPath, height: 75, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _hotDealCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset('assets/images/blue_bag.png'),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pure Water Rubbers', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text('GHS 0.45 per kg', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                Text('Top-rated Compounder', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE082),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('⭐ Top Rated', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _howToEarnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _earnStep('Collect Waste', 'assets/images/collect_waste.png'),
        _earnStep('Find Compounder', 'assets/images/find_compounder.png'),
        _earnStep('Exchange for Cash', 'assets/images/exchange_cash.png'),
      ],
    );
  }

  Widget _earnStep(String label, String assetPath) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: Image.asset(assetPath, width: 100, height: 100)),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 13), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _navIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF38B000),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (i) {
        setState(() => _navIndex = i);
        if (i == 1) {
          // Search tab → open SearchResultsScreen
          _openSearch();
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
        BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Learn'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
