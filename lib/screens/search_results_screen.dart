import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'filter_screen.dart';
import '../screens/favorites_badge_button.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery; // e.g., "pure water"
  const SearchResultsScreen({super.key, this.initialQuery = 'pure water'});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  // theme
  static const _bg = Color(0xFFFAF9F5);
  static const _chipBorder = Color(0xFFE6E2DA);
  static const _segBg = Color(0xFFEDEAE4);
  static const _green = Color(0xFF34C759);

  // image tiles (put these in assets + pubspec)
  static const _imgTopRated = 'assets/images/topratedcompounders.png';
  static const _imgRated = 'assets/images/ratedcompounders.png';

  // state
  final TextEditingController _query = TextEditingController();
  bool _materialType = true;
  bool _compounderLevel = true;
  FilterState _filters = FilterState.defaults();

  static const _favKey = 'search_results_favs';
  final Set<String> _favs = {};

  final List<_Item> _items = const [
    _Item(
      id: 'pwr-1',
      title: 'Pure Water Rubbers',
      pricePerKg: 1.00,
      rating: 4.9,
      ratingCount: 345,
      region: 'Greater Accra',
      image: 'assets/images/blue_bag.png',
      material: 'pure water rubber',
      level: 'Top Rated',
    ),
    _Item(
      id: 'pwr-2',
      title: 'Pure Water Rubbers',
      pricePerKg: 1.00,
      rating: 4.6,
      ratingCount: 211,
      region: 'Greater Accra',
      image: 'assets/images/blue_bag.png',
      material: 'pure water rubber',
      level: 'Rated',
    ),
    _Item(
      id: 'pb-1',
      title: 'Plastic Bottles',
      pricePerKg: 0.90,
      rating: 4.7,
      ratingCount: 180,
      region: 'Ashanti Region',
      image: 'assets/images/plastic.png',
      material: 'plastic bottle',
      level: 'Top Rated',
    ),
    _Item(
      id: 'gal-1',
      title: 'Yellow/Blue Gallons',
      pricePerKg: 0.65,
      rating: 4.5,
      ratingCount: 120,
      region: 'Central Region',
      image: 'assets/images/items.png',
      material: 'gallon',
      level: 'Level Two',
    ),
  ];

  final List<String> _related = const [
    'pure water rubber',
    'plastic bottle',
    'gallon',
    'rubber bowl',
    'pipe rubber',
  ];

  @override
  void initState() {
    super.initState();
    _query.text = 'Search for ${widget.initialQuery}…';
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    final p = await SharedPreferences.getInstance();
    _favs.addAll(p.getStringList(_favKey) ?? []);
    if (mounted) setState(() {});
  }

  Future<void> _toggleFav(String id) async {
    setState(() => _favs.contains(id) ? _favs.remove(id) : _favs.add(id));
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_favKey, _favs.toList());
  }

  Future<void> _openFilters() async {
    final picked = await Navigator.push<FilterState>(
      context,
      MaterialPageRoute(builder: (_) => FilterScreen(initial: _filters)),
    );
    if (picked != null) {
      setState(() => _filters = picked);
    }
  }

  void _applyChip(String term) {
    setState(() {
      _query.text = 'Search for $term…';
      _materialType = true;
    });
  }

  List<_Item> get _filtered {
    Iterable<_Item> list = _items;

    final q = _query.text
        .replaceAll('Search for ', '')
        .replaceAll('…', '')
        .trim()
        .toLowerCase();

    if (q.isNotEmpty) {
      list = list.where((e) =>
      e.title.toLowerCase().contains(q) ||
          e.material.toLowerCase().contains(q) ||
          e.region.toLowerCase().contains(q));
    }

    if (_materialType && _filters.materialChips.isNotEmpty) {
      final chips = _filters.materialChips.map((e) => e.toLowerCase()).toSet();
      list = list.where((e) => chips.any((c) => e.material.toLowerCase().contains(c)));
    }
    if (_filters.location.isNotEmpty) {
      list = list.where((e) => e.region == _filters.location);
    }
    if (_compounderLevel && _filters.level.isNotEmpty) {
      list = list.where((e) => e.level == _filters.level);
    }

    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            // 🔴 FAV BADGE IN HEADER
            Row(
              children: const [
                Spacer(),
                FavoritesBadgeButton(),
              ],
            ),
            const SizedBox(height: 6),

            _searchBar(),
            const SizedBox(height: 16),
            const Text('Related results',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            _relatedChips(),
            const SizedBox(height: 18),
            const Text('Sell by',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            _sellBySegment(),
            const SizedBox(height: 12),
            _imageFilterCards(),
            const SizedBox(height: 12),
            for (final it in results) ...[
              _resultCard(it),
              const SizedBox(height: 12),
            ],
            if (results.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: Text('No results. Try a different filter.')),
              ),
          ],
        ),
      ),
    );
  }

  // UI pieces

  Widget _searchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFECE7DE),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black87),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _query,
              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _relatedChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _related.map((t) {
          return GestureDetector(
            onTap: () => _applyChip(t),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _chipBorder),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _sellBySegment() {
    return Container(
      decoration: BoxDecoration(color: _segBg, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _seg(
            icon: Icons.view_list_rounded,
            label: 'All',
            selected: false,
            greyWhenUnselected: true,
            onTap: _openFilters, // open filter screen
          ),
          const SizedBox(width: 8),
          _seg(
            icon: Icons.check_circle,
            label: 'Material Type',
            selected: _materialType,
            onTap: () => setState(() => _materialType = !_materialType),
          ),
          const SizedBox(width: 8),
          _seg(
            icon: Icons.check_circle,
            label: 'Compounder Level',
            selected: _compounderLevel,
            onTap: () => setState(() => _compounderLevel = !_compounderLevel),
          ),
        ],
      ),
    );
  }

  Widget _seg({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool greyWhenUnselected = false,
  }) {
    final bg = selected
        ? _green
        : greyWhenUnselected
        ? const Color(0xFFD7D3CC)
        : Colors.white;
    final fg = selected ? Colors.white : Colors.black87;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 38,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // image tiles
  Widget _imageFilterCards() {
    Widget card(String assetPath, VoidCallback onTap) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x12000000))],
            ),
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
        ),
      );
    }

    return Row(
      children: [
        card(_imgTopRated, () => setState(() => _filters = _filters.copyWith(level: 'Top Rated'))),
        const SizedBox(width: 12),
        card(_imgRated, () => setState(() => _filters = _filters.copyWith(level: 'Rated'))),
      ],
    );
  }

  Widget _resultCard(_Item it) {
    final fav = _favs.contains(it.id);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x11000000))],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F1E6),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(it.image, width: 78, height: 78, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.star, size: 16, color: Colors.black87),
                  const SizedBox(width: 6),
                  Text(it.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(width: 6),
                  Text('(${it.ratingCount})',
                      style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ]),
                const SizedBox(height: 2),
                Text(it.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                const SizedBox(height: 4),
                Text('GHS ${it.pricePerKg.toStringAsFixed(2)} per kg',
                    style: const TextStyle(color: _green, fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text(it.region, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ]),
              ],
            ),
          ),
          InkWell(
            onTap: () => _toggleFav(it.id),
            child: Icon(
              fav ? Icons.favorite : Icons.favorite_border,
              size: 22,
              color: fav ? const Color(0xFFE57373) : Colors.black26,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

/* Data model */
class _Item {
  final String id, title, region, image, material, level;
  final double pricePerKg, rating;
  final int ratingCount;
  const _Item({
    required this.id,
    required this.title,
    required this.pricePerKg,
    required this.rating,
    required this.ratingCount,
    required this.region,
    required this.image,
    required this.material,
    required this.level,
  });
}
