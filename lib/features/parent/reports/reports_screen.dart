import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ GoRouter import
import '../../../services/hive/hive_service.dart';
import '../../../core/widgets/info_banner.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = HiveService.getTasks();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    // 🔹 Sticker istatistikleri
    final stickersBox = HiveService.stickersBox;
    final categories = {
      "princess": "Prensesler",
      "superheroes": "Süper Kahramanlar",
      "flowers": "Çiçekler",
      "cars": "Arabalar",
      "jobs": "Meslekler",
    };

    int totalStickers = 0;
    categories.forEach((c, _) {
      final list = (stickersBox.get(c, defaultValue: <String>[]) as List);
      totalStickers += list.length;
    });

    // 🔹 Gerçek ödüller
    final rewards = HiveService.getRealRewards();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Raporlar"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/parent/panel'), // ✅ geri dönüş
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/backgrounds/castle/bg_castle.png",
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 🔹 Özet Kartları (yan yana birleşik)
                Row(
                  children: [
                    Expanded(
                      child: _buildUnifiedStatCard(
                        title: "Görev Tamamlandı",
                        value: completedTasks.length.toString(),
                        color: Colors.deepPurple,
                        isLeft: true,
                      ),
                    ),
                    Expanded(
                      child: _buildUnifiedStatCard(
                        title: "Toplam Sticker",
                        value: totalStickers.toString(),
                        color: Colors.pink,
                        isRight: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔹 Tamamlanan Görevler
                _buildSectionTitle("Tamamlanan Görevler"),
                const SizedBox(height: 8),
                if (completedTasks.isEmpty)
                  const InfoBanner(
                    text:
                    "Henüz görev tamamlanmamış.\nGörevleri tamamladıkça burada listelenecek ✅",
                  )
                else
                  ...completedTasks.map(
                        (task) => Card(
                      color: Colors.white.withOpacity(0.85),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.check_circle,
                            color: Colors.green, size: 28),
                        title: Text(
                          task.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                        subtitle: Text(
                          "Kategori: ${task.category}",
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // 🔹 Sticker İstatistikleri
                _buildSectionTitle("Sticker İstatistikleri"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: categories.entries.map((entry) {
                    final key = entry.key;
                    final title = entry.value;
                    final stickers =
                    stickersBox.get(key, defaultValue: <String>[]) as List;

                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: 120,
                      child: Card(
                        color: Colors.white.withOpacity(0.85),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${stickers.length} adet",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: stickers.isEmpty
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // 🔹 Gerçek Ödüller
                _buildSectionTitle("Gerçek Ödüller"),
                const SizedBox(height: 8),
                if (rewards.isEmpty)
                  const InfoBanner(
                    text:
                    "Henüz ödül eklenmemiş.\nÇocuğun sticker biriktirdiğinde alabileceği ödülleri buradan yönetebilirsin 🎁",
                  )
                else
                  ...rewards.map(
                        (reward) => Card(
                      color: Colors.white.withOpacity(0.85),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.card_giftcard,
                            color: Colors.purple, size: 28),
                        title: Text(
                          reward,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Yan yana birleşik stat kartları
  Widget _buildUnifiedStatCard({
    required String title,
    required String value,
    required Color color,
    bool isLeft = false,
    bool isRight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? const Radius.circular(16) : Radius.zero,
          right: isRight ? const Radius.circular(16) : Radius.zero,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                )
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple.shade800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(1, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}
