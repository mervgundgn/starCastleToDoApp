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
    final categories = ["flowers", "cars", "princess", "superheroes", "jobs"];

    int totalStickers = 0;
    for (var c in categories) {
      final list = (stickersBox.get(c, defaultValue: <String>[]) as List);
      totalStickers += list.length;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Raporlama")),
      backgroundColor: AppColors.neutralGrey,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 🔹 Özet Kartları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("Görev Tamamlandı", completedTasks.length.toString(), Colors.green),
                _buildStatCard("Sticker", totalStickers.toString(), Colors.orange),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Tamamlanan Görevler
            const Text("Tamamlanan Görevler",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (completedTasks.isEmpty)
              const Text("Henüz görev tamamlanmamış.")
            else
              ...completedTasks.map(
                    (task) => ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(task.title),
                  subtitle: Text("Kategori: ${task.category}"),
                ),
              ),

            const SizedBox(height: 20),

            // 🔹 Sticker İstatistikleri
            const Text("Sticker İstatistikleri",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: categories.map((c) {
                final stickers = stickersBox.get(c, defaultValue: <String>[]) as List;
                return ListTile(
                  leading: const Icon(Icons.star, color: Colors.orange),
                  title: Text("$c koleksiyonu"),
                  trailing: Text("${stickers.length} sticker"),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 3,
      color: color.withOpacity(0.1),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
