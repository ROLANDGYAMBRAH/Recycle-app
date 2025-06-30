// File: lib/screens/material_list_screen.dart
import 'package:flutter/material.dart';

import 'search_results_screen.dart';
import 'favorites_repository.dart';

/// -------------------------------
/// Dummy marketplace data
/// -------------------------------
class _Listing {
  final String id;
  final String title;
  final String category; // Plastic | Glass | Paper | Metal
  final String price;
  final String image;
  final double rating;
  final int ratingCount;
  final String region;

  const _Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.image,
    required this.rating,
    required this.ratingCount,
    required this.region,
  });
}

const _allListings = <_Listing>[
  _Listing(
    id: 'pwr-1',
    title: 'Pure Water Rubbers',
    category: 'Plastic',
    price: 'GHS 1.00 per kg',
    image: 'assets/images/blue_bag.png',
    rating: 4.9,
    ratingCount: 345,
    region: 'Greater Accra',
  ),
  _Listing(
    id: 'pb-1',
    title: 'Plastic Bottle',
    category: 'Plastic',
    price: 'GHS 0.90 per kg',
    image: 'assets/images/blue_bag.png',
    rating: 4.8,
    ratingCount: 210,
    region: 'Ashanti',
  ),
  _Listing(
    id: 'gl-1',
    title: 'Green Glass Bottles',
    category: 'Glass',
    price: 'GHS 1.60 per kg',
    image: 'assets/images/glass.png',
    rating: 4.7,
    ratingCount: 120,
    region: 'Volta',
  ),
  _Listing(
    id: 'pa-1',
    title: 'Old Newspapers',
    category: 'Paper',
    price: 'GHS 0.50 per kg',
    image: 'assets/images/paper.png',
    rating: 4.6,
    ratingCount: 90,
    region: 'Central',
  ),
  _Listing(
    id: 'me-1',
    title: 'Aluminium Cans',
    category: 'Metal',
    price: 'GHS 2.20 per kg',
    image: 'assets/images/metal.png',
    rating: 4.9,
    ratingCount: 510,
    region: 'Greater Accra',
  ),
];

/// -------------------------------
/// Screen
/// -------------------------------
class MaterialListScreen extends StatefulWidget {
  final String materialName; // Plastic | Glass | Paper | Metal
  const MaterialListScreen({super.key, required this.materialName});

  @override
  State<MaterialListScreen> createState() => _MaterialListScreenState();
}

class _MaterialListScreenState extends State<MaterialListScreen> {
  String selectedPrimary = 'Materials Type'; // default like your mock
  List<String> materialTypeChips = const [];
  String? selectedChip;

  Map<String, List<String>> get _chipsByCategory => {
    'Plastic': [
      'Pure Water Rubbers',
      'Plastic Bottle',
      'Gallon (Yellow/Blue)',
      'Rubber Bowl',
      'Pipe Rubber',
    ],
    'Glass': ['Green Bottles', 'Brown Bottles', 'Clear Glass'],
    'Paper': ['Newspapers', 'Cardboard', 'Mixed Paper'],
    'Metal': ['Aluminium Cans', 'Steel', 'Copper'],
  };

  @override
  void initState() {
    super.initState();
    materialTypeChips = _chipsByCategory[widget.materialName] ?? [];
  }

  List<_Listing> get _filteredListings {
    List<_Listing> items;

    if (selectedPrimary == 'Materials Type') {
      items =
          _allListings.where((l) => l.category == widget.materialName).toList();
    } else if (selectedPrimary == 'All') {
      items = _allListings;
    } else if (selectedPrimary == 'Compounder Level') {
      items = [..._allListings]..sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      items = _allListings.where((l) => l.category == selectedPrimary).toList();
    }

    if (selectedPrimary == 'Materials Type' && (selectedChip ?? '').isNotEmpty) {
      final q = selectedChip!.toLowerCase();
      items = items.where((l) => l.title.toLowerCase().contains(q)).toList();
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final listings = _filteredListings;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          widget.materialName,
          style:
          const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subheading(),
          _primaryTabs(context),
          if (selectedPrimary == 'Materials Type') _materialTypeScroller(),
          const SizedBox(height: 10),

          // Live favourites stream so hearts update instantly
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: FavoritesRepository.watchIds(),
              initialData: const [],
              builder: (context, snap) {
                final favIds = snap.data ?? [];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: ListView.separated(
                    key: ValueKey(
                      '${selectedPrimary}_${selectedChip}_${listings.length}_${favIds.join(",")}',
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: listings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final l = listings[i];
                      final isFav = favIds.contains(l.id);
                      return _listingCard(l, isFav);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _subheading() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        'Take your recyclable materials to any of these compounders',
        style: TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  /// When the user taps **All**, push the Search Results screen.
  Widget _primaryTabs(BuildContext context) {
    final tabs = <String>['All', 'Materials Type', 'Compounder Level'];
    if (!tabs.contains(widget.materialName)) {
      tabs.insert(1, widget.materialName); // Plastic/Glass/Paper/Metal
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((t) {
          final selected = selectedPrimary == t;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(t),
              selected: selected,
              onSelected: (_) async {
                if (t == 'All') {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SearchResultsScreen()),
                  );
                  return; // don't change local tab when returning
                }

                setState(() {
                  selectedPrimary = t;
                  if (t == 'Materials Type') {
                    materialTypeChips =
                        _chipsByCategory[widget.materialName] ?? [];
                  }
                  selectedChip = null; // reset chip selection on tab switch
                });
              },
              selectedColor: const Color(0xFFDFF5D2),
              backgroundColor: const Color(0xFFF0F0F0),
              labelStyle: TextStyle(
                color: selected ? const Color(0xFF1B5E20) : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color:
                  selected ? const Color(0xFF38B000) : Colors.transparent,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _materialTypeScroller() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: materialTypeChips.map((c) {
          final isSelected = selectedChip == c;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(c),
                  const SizedBox(height: 2),
                  const Text('9,075 Offers',
                      style: TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
              selected: isSelected,
              onSelected: (_) =>
                  setState(() => selectedChip = isSelected ? null : c),
              selectedColor: const Color(0xFFDFF5D2),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF1B5E20) : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF38B000)
                      : const Color(0xFFE0E0E0),
                ),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _listingCard(_Listing l, bool isFav) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(l.image,
                height: 64, width: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 16),
                    const SizedBox(width: 4),
                    Text('${l.rating}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    Text('(${l.ratingCount})',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(l.title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(l.price,
                    style: const TextStyle(
                        color: Color(0xFF38B000),
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(l.region,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey),
            onPressed: () => FavoritesRepository.toggle(l.id),
            tooltip: isFav
                ? 'Remove from favourites'
                : 'Save to favourites',
          ),
        ],
      ),
    );
  }
}
