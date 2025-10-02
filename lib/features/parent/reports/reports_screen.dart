import 'package:flutter/material.dart';
import '../../../services/hive/hive_service.dart';
import '../../../models/task_model.dart';
import '../../../core/constants/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = HiveService.getTasks();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    // Sticker istatistikleri
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Raporlar"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1BEE7), Color(0xFFF8BBD0), Color(0xFFE3F2FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // 🔹 Özet Kartları → Wrap ile responsive
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: _buildStatCard(
                      "Görev Tamamlandı",
                      completedTasks.length.toString(),
                      Colors.deepPurple.shade300,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: _buildStatCard(
                      "Toplam Sticker",
                      totalStickers.toString(),
                      Colors.pink.shade300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Tamamlanan Görevler
              Text(
                "Tamamlanan Görevler",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade600,
                ),
              ),
              const SizedBox(height: 8),
              if (completedTasks.isEmpty)
                const Text("Henüz görev tamamlanmamış.")
              else
                ...completedTasks.map(
                      (task) => Card(
                    color: Colors.white.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle,
                          color: Colors.green, size: 28),
                      title: Text(task.title),
                      subtitle: Text("Kategori: ${task.category}"),
                      trailing: const Icon(Icons.star,
                          color: Colors.orange, size: 22),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // 🔹 Sticker İstatistikleri
              Text(
                "Sticker İstatistikleri",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade600,
                ),
              ),
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
                    width: MediaQuery.of(context).size.width * 0.42, // sabit genişlik
                    height: 120, // sabit yükseklik → hepsi eşit
                    child: Card(
                      color: Colors.white.withOpacity(0.8),
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
                              color: Colors.deepPurple.shade400,
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
                                  : Colors.deepPurple.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 3,
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
