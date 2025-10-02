import 'package:flutter/material.dart';
import '../../../services/hive/hive_service.dart';
import '../../../models/task_model.dart';
import '../../../core/widgets/info_banner.dart';

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
  }

  void _completeTask(int index, TaskModel task) {
    if (task.isCompleted) return;

    HiveService.completeTask(index);

    // Günlük görevler tamamlandı mı?
    if (task.period == "daily" && HiveService.areAllDailyTasksCompleted()) {
      final stickerPath = HiveService.addRandomSticker();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Harika 🎉"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Tüm günlük görevleri tamamladın! Kazandığın sticker:"),
              const SizedBox(height: 12),
              Image.asset(
                "assets/stickers/$stickerPath.png",
                width: 80,
                height: 80,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.red,
                ),
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
    }

    // Haftalık görev → ebeveyn ödülü popup
    if (task.period == "weekly") {
      final reward = HiveService.getRandomRealReward();
      if (reward != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Haftalık Görev Tamamlandı 🎁"),
            content: Text("Kazandığın ödül: $reward"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Süper!"),
              ),
            ],
          ),
        );
      }
    }

    setState(() {});
  }

  Widget _buildTaskGrid(List<TaskModel> tasks, String type) {
    if (tasks.isEmpty) {
      return Center(
        child: InfoBanner(
          text: type == "daily"
              ? "Henüz günlük görev yok 📋\nEbeveyn panelinden yeni görev ekleyebilirsin."
              : "Henüz haftalık görev yok 📅\nEbeveyn panelinden ekleyebilirsin.",
        ),
      );
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
        final isAutoWeekly = task.isWeeklyAuto;

        return GestureDetector(
          onTap: () => _completeTask(index, task),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: task.isCompleted
                  ? Colors.greenAccent.shade100.withOpacity(0.9)
                  : Colors.white.withOpacity(0.9),
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
                if (isAutoWeekly)
                  const Icon(Icons.star, size: 50, color: Colors.amber)
                else
                  Image.asset(
                    "assets/icons/icon_task_default.png",
                    width: 50,
                    height: 50,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.help_outline, size: 50),
                  ),
                const SizedBox(height: 8),
                Text(
                  task.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight:
                    isAutoWeekly ? FontWeight.bold : FontWeight.normal,
                    color: isAutoWeekly ? Colors.deepPurple : Colors.black,
                  ),
                ),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Görevler"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Günlük"),
            Tab(text: "Haftalık"),
          ],
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskGrid(dailyTasks, "daily"),
                _buildTaskGrid(weeklyTasks, "weekly"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
