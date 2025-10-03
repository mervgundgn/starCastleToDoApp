import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';
import 'collection_viewmodel.dart';

class CollectionDetailScreen extends ConsumerWidget {
  final String category;
  final String title;

  const CollectionDetailScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔹 Sticker listesi
    final stickers =
    ref.watch(collectionProvider.notifier).getStickersByCategory(category);

    // 🔹 Toplam kapasite
    final totalCount =
    ref.watch(collectionProvider.notifier).getLimitByCategory(category);

    // 🔹 Tamamlanma durumu
    final isCompleted = stickers.length >= totalCount;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "$title (${stickers.length} / $totalCount)",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arka plan
          Image.asset(
            "assets/backgrounds/castle/bg_castle.png",
            fit: BoxFit.cover,
          ),
          Container(color: Colors.white.withOpacity(0.2)),

          // İçerik
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: totalCount,
                itemBuilder: (context, index) {
                  final hasSticker = index < stickers.length;

                  return Container(
                    decoration: BoxDecoration(
                      color: hasSticker
                          ? AppColors.mintGreen.withOpacity(0.9)
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasSticker
                            ? Colors.green.withOpacity(0.5)
                            : Colors.black12,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 3,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: hasSticker
                        ? Image.asset(
                      "assets/stickers/$category/${stickers[index]}.png",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    )
                        : const Icon(Icons.lock_outline,
                        color: Colors.grey, size: 26),
                  );
                },
              ),
            ),
          ),

          // Tamamlanma animasyonu
          if (isCompleted)
            Center(
              child: Lottie.asset(
                "assets/animations/${_getAnimationFile(category)}",
                repeat: false,
              ),
            ),
        ],
      ),
    );
  }

  String _getAnimationFile(String category) {
    switch (category) {
      case "princess":
        return "anim_princess_complete.json";
      case "superheroes":
        return "anim_superhero_complete.json";
      case "flowers":
        return "anim_flower_complete.json";
      case "cars":
        return "anim_car_complete.json";
      case "jobs":
        return "anim_job_complete.json";
      default:
        return "anim_confetti.json";
    }
  }
}
