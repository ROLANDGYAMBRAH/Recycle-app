import 'package:flutter/material.dart';

class RegionSingleSelectScreen extends StatefulWidget {
  final String initialRegion;
  const RegionSingleSelectScreen({super.key, required this.initialRegion});

  @override
  State<RegionSingleSelectScreen> createState() =>
      _RegionSingleSelectScreenState();
}

class _RegionSingleSelectScreenState extends State<RegionSingleSelectScreen> {
  static const _green = Color(0xFF38B000);
  static const _border = Color(0xFFE9E9E9);

  final List<String> _regions = const [
    'Greater Accra',
    'Ashanti Region',
    'Volta',
    'Central Region',
    'Northern',
    'Bono',
    'Upper East',
    'Upper West',
    'Western',
    'Eastern',
    'Savannah',
    'Oti',
  ];

  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialRegion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Region'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _border),
        ),
      ),
      body: ListView.separated(
        itemCount: _regions.length,
        separatorBuilder: (_, __) =>
        const Divider(height: 1, thickness: 1, color: _border),
        itemBuilder: (context, i) {
          final r = _regions[i];
          final sel = r == _selected;
          return ListTile(
            title: Text(r, style: TextStyle(
              fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
            )),
            trailing:
            sel ? const Icon(Icons.check, color: _green) : const SizedBox(),
            onTap: () => setState(() => _selected = r),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, _selected),
            child: const Text('Apply'),
          ),
        ),
      ),
    );
  }
}
