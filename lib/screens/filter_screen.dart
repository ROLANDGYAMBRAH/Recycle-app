// lib/screens/filter_screen.dart
import 'package:flutter/material.dart';
import 'material_type_single_select_screen.dart';
import 'compounder_location_sheet.dart'; // <-- correct import

class FilterState {
  final String materialGroup;
  final Set<String> materialChips;
  final String location;
  final String level;

  const FilterState({
    required this.materialGroup,
    required this.materialChips,
    required this.location,
    required this.level,
  });

  factory FilterState.defaults() => const FilterState(
    materialGroup: 'All Compounders into Plastics',
    materialChips: {'gallon', 'pure water rubber', 'plastic bottle'},
    location: 'Greater Accra',
    level: 'Top Rated',
  );

  FilterState copyWith({
    String? materialGroup,
    Set<String>? materialChips,
    String? location,
    String? level,
  }) {
    return FilterState(
      materialGroup: materialGroup ?? this.materialGroup,
      materialChips: materialChips ?? this.materialChips,
      location: location ?? this.location,
      level: level ?? this.level,
    );
  }
}

class FilterScreen extends StatefulWidget {
  final FilterState? initial;
  const FilterScreen({super.key, this.initial});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  static const Color kGreen = Color(0xFF38B000);
  static const Color kGreenSoft = Color(0xFFEFF7E6);
  static const Color kInk = Color(0xFF141414);
  static const Color kBorder = Color(0xFFDDDDDD);
  static const double kRadius = 8;

  static const String kAllPlastics = 'All Compounders into Plastics';
  static const String kAllPlasticsAlt = 'All Compounders Into Plastics (1,837)';

  late String _materialGroup;
  late Set<String> _materialChips;
  late String _location;
  late String _level;

  final _locations = <String>[
    'Greater Accra',
    'Ashanti Region',
    'Volta',
    'Central Region',
    'Northern',
  ];
  final _levels = <String>['Top Rated', 'Level Two', 'Level Three'];

  @override
  void initState() {
    super.initState();
    final init = widget.initial ?? FilterState.defaults();
    _materialGroup = init.materialGroup;
    _materialChips = {...init.materialChips};
    _location = init.location;
    _level = init.level;
  }

  void _clearAll() {
    final d = FilterState.defaults();
    setState(() {
      _materialGroup = d.materialGroup;
      _materialChips = {...d.materialChips};
      _location = d.location;
      _level = d.level;
    });
  }

  FilterState _collect() => FilterState(
    materialGroup: _materialGroup,
    materialChips: _materialChips,
    location: _location,
    level: _level,
  );

  // +2 more → Material Type
  Future<void> _openMaterialTypeSelector() async {
    final picked = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => MaterialTypeSingleSelectScreen(
          initialSelection:
          _materialGroup == kAllPlastics ? kAllPlasticsAlt : _materialGroup,
        ),
      ),
    );
    if (picked == null) return;

    final normalized =
    picked.toLowerCase().startsWith('all compound') ? kAllPlastics : picked;

    setState(() {
      _materialGroup = normalized;
      if (normalized == kAllPlastics) return;
      _materialChips = {normalized.toLowerCase().split(' (').first};
    });
  }

  // +15 more → Compounder Location
  Future<void> _openRegionSelector() async {
    final picked = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => CompounderLocationSingleSelectScreen(
          initialSelection: '${_location} (1,837)', // just to preselect visually
        ),
      ),
    );
    if (picked == null) return;

    // keep only the plain region (strip the count)
    final normalized = picked.split(' (').first;
    setState(() => _location = normalized);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Filters',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: const Text('Clear All',
                style: TextStyle(color: kGreen, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        children: [
          _section('Material Type'),
          const SizedBox(height: 10),
          _chip(
            kAllPlastics,
            selected: _materialGroup == kAllPlastics,
            onTap: () => setState(() => _materialGroup = kAllPlastics),
            selectedBg: kGreenSoft,
            selectedBorder: kGreen,
            selectedText: kGreen,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in const ['gallon', 'pure water rubber', 'plastic bottle'])
                _chip(
                  m,
                  selected: _materialChips.contains(m),
                  onTap: () => setState(() {
                    if (_materialChips.contains(m)) {
                      _materialChips.remove(m);
                    } else {
                      _materialChips.add(m);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _more('+ 2 more', onTap: _openMaterialTypeSelector),

          const SizedBox(height: 18),
          _section('Compounder location'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final loc in _locations)
                _chip(
                  loc,
                  selected: _location == loc,
                  onTap: () => setState(() => _location = loc),
                  selectedBg: kGreenSoft,
                  selectedBorder: kGreen,
                  selectedText: kGreen,
                ),
            ],
          ),
          const SizedBox(height: 8),
          _more('+ 15 more', onTap: _openRegionSelector),

          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Compounder level',
                  style: TextStyle(color: kInk, fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
              Icon(Icons.help_outline, size: 16, color: Colors.black45),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final lvl in _levels)
                _chip(
                  lvl,
                  selected: _level == lvl,
                  onTap: () => setState(() => _level = lvl),
                  selectedBg: kGreenSoft,
                  selectedBorder: kGreen,
                  selectedText: kGreen,
                  leading: _level == lvl
                      ? const Icon(Icons.check, size: 14, color: kGreen)
                      : null,
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: kGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            onPressed: () => Navigator.pop(context, _collect()),
            child: const Text('Show Results'),
          ),
        ),
      ),
    );
  }

  // helpers
  Widget _section(String text) => Text(
    text,
    style: const TextStyle(color: kInk, fontSize: 15, fontWeight: FontWeight.w800),
  );

  Widget _more(String text, {VoidCallback? onTap}) => InkWell(
    borderRadius: BorderRadius.circular(6),
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: const TextStyle(color: kGreen, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 16, color: kGreen),
        ],
      ),
    ),
  );

  Widget _chip(
      String label, {
        required bool selected,
        required VoidCallback onTap,
        Color selectedBg = Colors.white,
        Color selectedBorder = kBorder,
        Color selectedText = kInk,
        Widget? leading,
      }) {
    final bg = selected ? selectedBg : Colors.white;
    final borderColor = selected ? selectedBorder : kBorder;
    final textColor = selected ? selectedText : kInk;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                leading,
                const SizedBox(width: 6),
              ],
              Text(label, style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
