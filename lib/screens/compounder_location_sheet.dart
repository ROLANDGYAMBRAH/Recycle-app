// File: lib/screens/compounder_location_single_select_screen.dart
import 'package:flutter/material.dart';

class CompounderLocationSingleSelectScreen extends StatefulWidget {
  const CompounderLocationSingleSelectScreen({
    super.key,
    this.initialSelection = 'Greater Accra (1,837)',
  });

  final String initialSelection;

  @override
  State<CompounderLocationSingleSelectScreen> createState() =>
      _CompounderLocationSingleSelectScreenState();
}

class _CompounderLocationSingleSelectScreenState
    extends State<CompounderLocationSingleSelectScreen> {
  // Theme tokens to match your UI
  static const _green = Color(0xFF38B000);
  static const _border = Color(0xFFE9E9E9);
  static const _ink = Color(0xFF111111);

  final TextEditingController _search = TextEditingController();

  // Exact labels like your mock (include counts in parentheses)
  static const String kDefault = 'Greater Accra (1,837)';

  final List<_RowItem> _all = const [
    _RowItem('Greater Accra (1,837)', isTop: true),
    _RowItem('Ashanti Region (15)'),
    _RowItem('Volta (9)'),
    _RowItem('Northern (83)'),
    _RowItem('Central (166)'),
    _RowItem('Brong Ahafo (57)'),
  ];

  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection.isNotEmpty ? widget.initialSelection : kDefault;
  }

  List<_RowItem> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _all;
    return _all.where((e) => e.label.toLowerCase().contains(q)).toList();
  }

  void _clear() {
    setState(() {
      _search.clear();
      _selected = kDefault; // reset to first/top as in your mock
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
          'Compounder Location',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clear,
            child: const Text(
              'clear',
              style: TextStyle(
                color: _green,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _border),
        ),
      ),

      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16),
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

          // List
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            r.label,
                            // First/top row (“Greater Accra…”) is green like your mock
                            style: TextStyle(
                              color: r.isTop ? _green : _ink,
                              fontWeight: r.isTop ? FontWeight.w700 : FontWeight.w600,
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

      // Sticky “Apply” button with rounded pill look
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
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            onPressed: () => Navigator.pop<String>(context, _selected),
            child: const Text('Apply'),
          ),
        ),
      ),
    );
  }

  // Right-side check indicator to match screenshot
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
      decoration: const BoxDecoration(
        color: _green,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 22),
    );
  }
}

class _RowItem {
  final String label;
  final bool isTop; // only the first line is green in your design
  const _RowItem(this.label, {this.isTop = false});
}
