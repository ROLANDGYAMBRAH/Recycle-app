import 'package:flutter/material.dart';

class MaterialTypeSingleSelectScreen extends StatefulWidget {
  final String? initialSelection; // e.g. "All Compounders into Plastics"
  const MaterialTypeSingleSelectScreen({super.key, this.initialSelection});

  @override
  State<MaterialTypeSingleSelectScreen> createState() =>
      _MaterialTypeSingleSelectScreenState();
}

class _MaterialTypeSingleSelectScreenState
    extends State<MaterialTypeSingleSelectScreen> {
  static const _green = Color(0xFF38B000);
  static const _border = Color(0xFFE9E9E9);
  static const _ink = Color(0xFF111111);

  final TextEditingController _search = TextEditingController();

  // Keep this label EXACT (we normalize it in FilterScreen)
  static const String kAllLabel = 'All Compounders Into Plastics (1,837)';

  final List<_RowItem> _all = const [
    _RowItem(kAllLabel, isAll: true),
    _RowItem('Pure Water Rubber (15)'),
    _RowItem('Plastic Bottle (9)'),
    _RowItem('Gallon(Yellow/Blue) (83)'),
    _RowItem('Rubber Bowl (166)'),
    _RowItem('Pipe Rubber (57)'),
  ];

  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection ?? kAllLabel;
  }

  List<_RowItem> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _all;
    return _all.where((e) => e.label.toLowerCase().contains(q)).toList();
  }

  void _clear() {
    setState(() {
      _search.clear();
      _selected = kAllLabel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Material Type',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: _clear,
            child: const Text('clear',
                style: TextStyle(color: _green, fontWeight: FontWeight.w700)),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _border),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black45),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _border),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: rows.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 1, thickness: 1, color: _border),
              itemBuilder: (context, i) {
                final r = rows[i];
                final isSelected = _selected == r.label;
                return InkWell(
                  onTap: () => setState(() => _selected = r.label),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            r.label,
                            style: TextStyle(
                              color: r.isAll ? _green : _ink,
                              fontWeight:
                              r.isAll ? FontWeight.w700 : FontWeight.w600,
                              fontSize: 18,
                              height: 1.1,
                            ),
                          ),
                        ),
                        _tick(isSelected),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: SizedBox(
          height: 52,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            onPressed: () => Navigator.pop<String>(context, _selected),
            child: const Text('Apply'),
          ),
        ),
      ),
    );
  }

  Widget _tick(bool on) {
    if (!on) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26, width: 2),
          color: Colors.white,
        ),
      );
    }
    return Container(
      width: 36,
      height: 36,
      decoration:
      const BoxDecoration(color: _green, shape: BoxShape.circle),
      child: const Icon(Icons.check, color: Colors.white, size: 22),
    );
  }
}

class _RowItem {
  final String label;
  final bool isAll;
  const _RowItem(this.label, {this.isAll = false});
}
