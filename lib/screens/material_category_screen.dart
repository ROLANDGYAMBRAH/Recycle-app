import 'package:flutter/material.dart';
import 'material_list_screen.dart';

class MaterialCategoryScreen extends StatelessWidget {
  const MaterialCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      _Mat('Plastic', 'assets/images/plastic.png'),
      _Mat('Glass',   'assets/images/glass.png'),
      _Mat('Paper',   'assets/images/paper.png'),
      _Mat('Metal',   'assets/images/metal.png'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Materials',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          _searchBar(),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, i) {
              final it = items[i];
              return _materialCard(
                context: context,
                label: it.label,
                assetPath: it.asset,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE8EBEF)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.black54),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for materials',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _materialCard({
    required BuildContext context,
    required String label,
    required String assetPath,
  }) {
    return GestureDetector(
      onTap: () {
        // Pass the chosen category down so the next screen pre-filters
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MaterialListScreen(materialName: label),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  assetPath,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Mat {
  final String label;
  final String asset;
  const _Mat(this.label, this.asset);
}
