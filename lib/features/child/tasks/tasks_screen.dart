import 'package:flutter/material.dart';
import '../../../services/hive/hive_service.dart';
import '../../../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    // 🔹 Varsayılan görevleri ekle (ilk açılışta)
    if (HiveService.getTasks().isEmpty) {
      HiveService.addTask(TaskModel(title: "Diş fırçala", category: "flowers"));
      HiveService.addTask(TaskModel(title: "Su iç", category: "cars"));
      HiveService.addTask(TaskModel(title: "Kitap oku", category: "princess"));
      HiveService.addTask(TaskModel(title: "Oyuncakları topla", category: "superheroes"));
      setState(() {}); // UI'yi güncelle
    }
  }

  void _completeTask(int index, TaskModel task) {
    if (task.isCompleted) return;

    // 🔹 Görev tamamlandı
    HiveService.completeTask(index);

    // 🔹 Sticker kazan
    final sticker = HiveService.addRandomSticker(task.category);

    // 🔹 Ödül popup
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tebrikler 🎉"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Görevi tamamladın! Sticker kazandın:"),
            const SizedBox(height: 12),
            Image.asset(
              "assets/stickers/${task.category}/$sticker.png",
              width: 80,
              height: 80,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 60, color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tamam"),
          ),
        ],
      ),
    );

    setState(() {}); // UI güncelle
  }

  @override
  Widget build(BuildContext context) {
    final tasks = HiveService.getTasks();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: tasks.isEmpty
          ? const Center(child: Text("Henüz görev yok"))
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return GestureDetector(
            onTap: () => _completeTask(index, task),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? Colors.greenAccent.shade100
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔹 Default ikon
                  Image.asset(
                    "assets/icons/icon_task_default.png",
                    width: 50,
                    height: 50,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.help_outline, size: 50),
                  ),
                  const SizedBox(height: 8),
                  Text(task.title),
                  if (task.isCompleted)
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 28),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
