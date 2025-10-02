import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/hive/hive_service.dart';

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = {
      "princess": {
        "title": "Prensesler",
        "count": 20,
        "color": AppColors.softPink,
        "cover": "assets/albums/princess/princess_cover.png"
      },
      "superheroes": {
        "title": "Süper Kahramanlar",
        "count": 20,
        "color": AppColors.primaryBlue,
        "cover": "assets/albums/superheroes/superhero_cover.png"
      },
      "flowers": {
        "title": "Çiçekler",
        "count": 20,
        "color": AppColors.mintGreen,
        "cover": "assets/albums/flowers/flower_cover.png"
      },
      "cars": {
        "title": "Arabalar",
        "count": 20,
        "color": AppColors.sunnyYellow,
        "cover": "assets/albums/cars/car_cover.png"
      },
      "jobs": {
        "title": "Meslekler",
        "count": 10,
        "color": AppColors.pastelPurple,
        "cover": "assets/albums/jobs/job_cover.png"
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Koleksiyon"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.neutralGrey,
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: collections.entries.map((entry) {
          final key = entry.key;
          final title = entry.value["title"] as String;
          final totalCount = entry.value["count"] as int;
          final color = entry.value["color"] as Color;
          final cover = entry.value["cover"] as String;

          final stickers =
          HiveService.stickersBox.get(key, defaultValue: <String>[]) as List;
          final collectedCount = stickers.length;
          final progress = collectedCount / totalCount;

          return GestureDetector(
            onTap: () => context.push("/collection/$key", extra: {
              "title": title,
              "color": color,
            }),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.7),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 📕 Kapak resmi
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.asset(
                        cover,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 64),
                      ),
                    ),
                  ),
                  // 📖 Alt bilgi alanı
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color.darken(),
                            )),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            color: color,
                            backgroundColor: Colors.grey[200],
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$collectedCount / $totalCount",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 🔹 küçük renk koyulaştırma helper
extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
