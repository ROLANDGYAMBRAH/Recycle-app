import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const _key = 'fav_listing_ids';

  /// Returns a *copy* of the saved ids.
  static Future<List<String>> getIds() async {
    final p = await SharedPreferences.getInstance();
    return List<String>.from(p.getStringList(_key) ?? const []);
  }

  static Future<void> setIds(List<String> ids) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_key, ids);
  }

  static Future<void> toggle(String id) async {
    final ids = await getIds();
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    await setIds(ids);
  }

  static Future<bool> isFav(String id) async {
    final ids = await getIds();
    return ids.contains(id);
  }

  static Stream<List<String>> watchIds({Duration poll = const Duration(milliseconds: 400)}) async* {
    // Dumb polling watcher—fine for local demo; swap for Riverpod/Bloc in prod.
    List<String> last = await getIds();
    yield last;
    while (true) {
      await Future.delayed(poll);
      final cur = await getIds();
      if (cur.join(',') != last.join(',')) {
        last = cur;
        yield cur;
      }
    }
  }
}
