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
        title: const Text("Koleksiyon"),
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
                          onTap: () => context.push("/collection/$key", extra: {
                            "title": title,
                          }),
                          child: Card(
                            color: Colors.white.withOpacity(0.88),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
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
                                        child: Icon(Icons.photo_album_outlined,
                                            size: 48),
                                      ),
                                    ),
                                  ),
                                ),
                                // 📖 Alt bilgi alanı
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: progress.clamp(0.0, 1.0),
                                          color: AppColors.pastelPurple,
                                          backgroundColor: Colors.grey[200],
                                          minHeight: 6,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "$collectedCount / $totalCount",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
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
