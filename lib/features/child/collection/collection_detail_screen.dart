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
    // 🔹 Sticker listesi provider’dan
    final stickers =
    ref.watch(collectionProvider.notifier).getStickersByCategory(category);

    // 🔹 Limit provider’dan alınıyor
    final totalCount =
    ref.watch(collectionProvider.notifier).getLimitByCategory(category);

    // 🔹 Koleksiyon tamamlanma durumu
    final isCompleted = stickers.length >= totalCount;

    return Scaffold(
      appBar: AppBar(
        title: Text("$title (${stickers.length} / $totalCount)"),
        backgroundColor: AppColors.pastelPurple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.neutralGrey,
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: totalCount,
            itemBuilder: (context, index) {
              final hasSticker = index < stickers.length;

              return Container(
                decoration: BoxDecoration(
                  color: hasSticker ? AppColors.mintGreen : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: hasSticker
                    ? Image.asset(
                  "assets/stickers/$category/${stickers[index]}.png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
                )
                    : const Icon(Icons.lock_outline, color: Colors.grey),
              );
            },
          ),

          // 🔹 Koleksiyon tamamlandıysa kategoriye özel animasyon
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
