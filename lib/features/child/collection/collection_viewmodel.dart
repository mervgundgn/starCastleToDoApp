import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final collectionProvider =
StateNotifierProvider<CollectionNotifier, Map<String, List<String>>>(
      (ref) => CollectionNotifier(),
);

class CollectionNotifier extends StateNotifier<Map<String, List<String>>> {
  CollectionNotifier() : super({}) {
    _loadStickers();
  }

  // 🔹 Koleksiyon limitleri
  final Map<String, int> _limits = {
    "princess": 20,
    "superheroes": 20,
    "flowers": 20,
    "cars": 20,
    "jobs": 10,
  };

  Future<void> _loadStickers() async {
    final box = Hive.box("stickersBox");
    final data = Map<String, List<String>>.from(
      box.toMap().map(
            (key, value) => MapEntry(key.toString(), List<String>.from(value)),
      ),
    );
    state = data;
  }

  List<String> getStickersByCategory(String category) {
    return state[category] ?? [];
  }

  bool isCategoryCompleted(String category) {
    final stickers = getStickersByCategory(category);
    final limit = _limits[category] ?? 0;
    return stickers.length >= limit;
  }

  int getLimitByCategory(String category) {
    return _limits[category] ?? 0;
  }
}
