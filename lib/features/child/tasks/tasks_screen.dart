import 'package:flutter/material.dart';
import '../../../services/hive/hive_service.dart';
import '../../../models/task_model.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/constants/app_colors.dart';

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

  void _completeTask(TaskModel task) {
    if (task.isCompleted) return;

    HiveService.completeTask(task);

    if (task.period == "daily" && HiveService.areAllDailyTasksCompleted()) {
      final stickerPath = HiveService.addRandomSticker();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.neutralGrey.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Harika 🎉",
              style: TextStyle(fontWeight: FontWeight.bold)),
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

    if (task.period == "weekly") {
      final reward = HiveService.getRandomRealReward();
      if (reward != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.neutralGrey.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
          onTap: () => _completeTask(task),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            decoration: BoxDecoration(
              color: task.isCompleted
                  ? AppColors.mintGreen.withOpacity(0.6)
                  : AppColors.neutralGrey.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: task.isCompleted
                    ? Colors.green.withOpacity(0.4)
                    : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isAutoWeekly)
                  const Icon(Icons.star, size: 44, color: Colors.amber)
                else
                  Image.asset(
                    "assets/icons/icon_task_default.png",
                    width: 44,
                    height: 44,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.help_outline, size: 44),
                  ),
                const SizedBox(height: 8),
                Text(
                  task.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight:
                    isAutoWeekly ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                if (task.isCompleted)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child:
                    Icon(Icons.check_circle, color: Colors.green, size: 24),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Görevleri her açılışta resetle
    HiveService.resetExpiredTasks();

    final tasks = HiveService.getTasks();
    final dailyTasks = tasks.where((t) => t.period == "daily").toList();
    final weeklyTasks = tasks.where((t) => t.period == "weekly").toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Görevler",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
          Container(color: Colors.white.withOpacity(0.25)),
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
