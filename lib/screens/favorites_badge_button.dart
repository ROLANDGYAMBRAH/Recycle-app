import 'package:flutter/material.dart';
import '../screens/favorites_screen.dart';
import '../screens/favorites_repository.dart';

class FavoritesBadgeButton extends StatelessWidget {
  const FavoritesBadgeButton({super.key, this.iconSize = 24});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: FavoritesRepository.watchIds(),
      initialData: const [],
      builder: (context, snap) {
        final count = snap.data?.length ?? 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              tooltip: 'Favourites',
              icon: Icon(
                count > 0 ? Icons.favorite : Icons.favorite_border,
                color: count > 0 ? const Color(0xFFE57373) : Colors.black54,
                size: iconSize,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
            if (count > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
