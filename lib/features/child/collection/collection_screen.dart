import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../services/hive/hive_service.dart';

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = {
      "princess": {
        "title": "Prensesler",
        "count": 20,
        "cover": "assets/albums/princess/princess_cover.png"
      },
      "superheroes": {
        "title": "Süper Kahramanlar",
        "count": 20,
        "cover": "assets/albums/superheroes/superhero_cover.png"
      },
      "flowers": {
        "title": "Çiçekler",
        "count": 20,
        "cover": "assets/albums/flowers/flower_cover.png"
      },
      "cars": {
        "title": "Arabalar",
        "count": 20,
        "cover": "assets/albums/cars/car_cover.png"
      },
      "jobs": {
        "title": "Meslekler",
        "count": 10,
        "cover": "assets/albums/jobs/job_cover.png"
      },
    };

    final hasAnySticker = collections.keys.any((key) {
      final list = HiveService.stickersBox.get(key, defaultValue: <String>[]);
      return list is List && list.isNotEmpty;
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Koleksiyon",
          style: TextStyle(
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
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Arka plan
          Image.asset(
            "assets/backgrounds/castle/bg_castle.png",
            fit: BoxFit.cover,
          ),

          // 🔹 Overlay – kontrastı yumuşat
          Container(color: Colors.white.withOpacity(0.22)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (!hasAnySticker)
                    const InfoBanner(
                      text:
                      "Henüz stickerlara başlamadın ✨\nDefterlerden birini aç ve ilk sayfayı doldurmaya başla!",
                    ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: collections.entries.map((entry) {
                        final key = entry.key;
                        final title = entry.value["title"] as String;
                        final totalCount = entry.value["count"] as int;
                        final cover = entry.value["cover"] as String;

                        final dynamicRaw = HiveService.stickersBox.get(
                          key,
                          defaultValue: <String>[],
                        );
                        final List<String> stickers = (dynamicRaw is List)
                            ? dynamicRaw.map((e) => e.toString()).toList()
                            : const <String>[];

                        final collectedCount = stickers.length;
                        final progress =
                        totalCount > 0 ? collectedCount / totalCount : 0.0;

                        return GestureDetector(
                          onTap: () => context.push(
                            "/collection/$key",
                            extra: {"title": title},
                          ),
                          child: Card(
                            color: Colors.white.withOpacity(0.9),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Icon(
                                          Icons.photo_album_outlined,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // 📖 Alt bilgi
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.92),
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: progress.clamp(0.0, 1.0),
                                          color: AppColors.primaryBlue
                                              .withOpacity(0.85),
                                          backgroundColor:
                                          Colors.grey.withOpacity(0.2),
                                          minHeight: 6,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "$collectedCount / $totalCount",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.7),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
