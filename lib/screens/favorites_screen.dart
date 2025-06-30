import 'package:flutter/material.dart';
import 'favorites_repository.dart';
import 'listings_data.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<String>> _futureIds;

  @override
  void initState() {
    super.initState();
    _futureIds = FavoritesRepository.getIds();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureIds = FavoritesRepository.getIds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<String>>(
        future: _futureIds,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final ids = snap.data!;
          final items = kAllListings.where((e) => ids.contains(e.id)).toList();

          if (items.isEmpty) {
            return const Center(
              child: Text("No favourites yet.\nTap the heart to save something.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final l = items[i];
                return Dismissible(
                  key: ValueKey(l.id),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) async {
                    await FavoritesRepository.toggle(l.id);
                    _refresh();
                  },
                  child: _FavTile(listing: l, onUnfavourite: () async {
                    await FavoritesRepository.toggle(l.id);
                    _refresh();
                  }),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _FavTile extends StatelessWidget {
  final Listing listing;
  final VoidCallback onUnfavourite;
  const _FavTile({required this.listing, required this.onUnfavourite});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(listing.image, width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(listing.price, style: const TextStyle(color: Color(0xFF38B000), fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(listing.region, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: onUnfavourite,
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}
