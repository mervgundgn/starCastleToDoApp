import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../services/hive/hive_service.dart';

class CollectionDetailScreen extends StatefulWidget {
  final String category;
  final String title;

  const CollectionDetailScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  late List stickers;
  bool showAnimation = false;

  // 🔹 Kategori limitleri (tam koleksiyon için)
  final limits = {
    "princess": 20,
    "superheroes": 20,
    "flowers": 20,
    "cars": 20,
    "jobs": 10,
  };

  // 🔹 Koleksiyon tamamlandığında oynatılacak animasyonlar
  final animations = {
    "princess": "assets/animations/anim_confetti.json",
    "superheroes": "assets/animations/anim_confetti.json",
    "flowers": "assets/animations/anim_confetti.json",
    "cars": "assets/animations/anim_confetti.json",
    "jobs": "assets/animations/anim_confetti.json",
  };

  @override
  void initState() {
    super.initState();
    // Hive’dan sticker listesini çek
    stickers = HiveService.stickersBox.get(widget.category, defaultValue: <String>[])!;

    // Koleksiyon tamamlandı mı kontrol et
    final limit = limits[widget.category] ?? 0;
    if (stickers.length >= limit && limit > 0) {
      showAnimation = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          // 🔹 Sticker grid
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: stickers.length,
            itemBuilder: (context, index) {
              final sticker = stickers[index];
              return Image.asset(
                "assets/stickers/${widget.category}/$sticker.png",
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported),
              );
            },
          ),

          // 🔹 Koleksiyon tamamlandığında animasyon göster
          if (showAnimation)
            Center(
              child: Lottie.asset(
                animations[widget.category] ?? "",
                repeat: false,
                onLoaded: (_) {
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      setState(() => showAnimation = false);
                    }
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
