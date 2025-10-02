import 'package:flutter/material.dart';
import '../../../services/hive/hive_service.dart';
import '../../../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    // 🔹 Varsayılan görevler eklenir (ilk açılışta)
    if (HiveService.getTasks().isEmpty) {
      HiveService.addTask(TaskModel(
          title: "Diş fırçala", category: "flowers", period: "daily"));
      HiveService.addTask(TaskModel(
          title: "Su iç", category: "cars", period: "daily"));
      HiveService.addTask(TaskModel(
          title: "Kitap oku", category: "princess", period: "weekly"));
      HiveService.addTask(TaskModel(
          title: "Oyuncakları topla",
          category: "superheroes",
          period: "weekly"));
      setState(() {});
    }
  }

  void _completeTask(int index, TaskModel task) {
    if (task.isCompleted) return;

    HiveService.completeTask(index);

    final stickerPath = HiveService.addRandomSticker();

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
              "assets/stickers/$stickerPath.png",
              width: 80,
              height: 80,
              errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.red),
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

    setState(() {});
  }

  Widget _buildTaskGrid(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text("Henüz görev yok"));
    }

    return GridView.builder(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = HiveService.getTasks();
    final dailyTasks = tasks.where((t) => t.period == "daily").toList();
    final weeklyTasks = tasks.where((t) => t.period == "weekly").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Görevler"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Günlük"),
            Tab(text: "Haftalık"),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskGrid(dailyTasks),
          _buildTaskGrid(weeklyTasks),
        ],
      ),
    );
  }
}
