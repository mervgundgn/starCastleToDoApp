import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/task_model.dart';

class HiveService {
  static late Box<TaskModel> tasksBox;
  static late Box<dynamic> stickersBox;
  static late Box settingsBox;

  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }

    tasksBox = Hive.isBoxOpen('tasksBox')
        ? Hive.box<TaskModel>('tasksBox')
        : await Hive.openBox<TaskModel>('tasksBox');

    stickersBox = Hive.isBoxOpen('stickersBox')
        ? Hive.box<dynamic>('stickersBox')
        : await Hive.openBox<dynamic>('stickersBox');

    settingsBox = Hive.isBoxOpen('settingsBox')
        ? Hive.box('settingsBox')
        : await Hive.openBox('settingsBox');

    // Varsayılan haftalık görev
    final exists = tasksBox.values.any((t) => t.isWeeklyAuto);
    if (!exists) {
      final defaultWeekly = TaskModel(
        title: "7 Günlük Görevleri Tamamlama",
        category: "progress",
        period: "weekly",
        isWeeklyAuto: true,
      );
      await tasksBox.add(defaultWeekly);
    }
  }

  // ---------------- Görevler ----------------

  static void addTask(TaskModel task) {
    tasksBox.add(task);
  }

  static List<TaskModel> getTasks() {
    return tasksBox.values.toList();
  }

  static void completeTask(TaskModel task) {
    task.isCompleted = true;
    task.save();
  }


  static bool areAllDailyTasksCompleted() {
    final tasks = getTasks();
    final daily = tasks.where((t) => t.period == "daily").toList();
    if (daily.isEmpty) return false;
    return daily.every((t) => t.isCompleted);
  }

  /// 🔹 Görev reset mekanizması (daily/weekly reset)
  static void resetExpiredTasks() {
    final now = DateTime.now();
    for (var task in tasksBox.values) {
      if (task.isCompleted && task.lastCompleted != null) {
        final diff = now.difference(task.lastCompleted!);

        if (task.period == "daily" && diff.inDays >= 1) {
          task.isCompleted = false;
          task.save();
        }

        if (task.period == "weekly" && diff.inDays >= 7) {
          task.isCompleted = false;
          task.save();
        }
      }
    }
  }

  // ---------------- Stickerlar ----------------

  static String addRandomSticker() {
    final random = Random();

    final limits = {
      "cars": 20,
      "flowers": 20,
      "jobs": 10,
      "princess": 20,
      "superheroes": 20,
    };

    final prefixes = {
      "cars": "car",
      "flowers": "flower",
      "jobs": "job",
      "princess": "princess",
      "superheroes": "superhero",
    };

    final categories = limits.keys.toList();
    final category = categories[random.nextInt(categories.length)];
    final total = limits[category]!;
    final index = random.nextInt(total) + 1;

    final prefix = prefixes[category]!;
    final sticker = "${prefix}_${index.toString().padLeft(2, '0')}";

    final current = stickersBox.get(category, defaultValue: <String>[]);
    final updated = List<String>.from(current)..add(sticker);
    stickersBox.put(category, updated);

    return "$category/$sticker";
  }

  static List<String> getStickersByCategory(String category) {
    final list = stickersBox.get(category, defaultValue: <String>[]);
    return List<String>.from(list);
  }

  static Map<String, List<String>> getAllStickers() {
    final result = <String, List<String>>{};
    for (var key in stickersBox.keys) {
      result[key.toString()] =
      List<String>.from(stickersBox.get(key, defaultValue: <String>[]));
    }
    return result;
  }

  // ---------------- Ödüller ----------------

  static void addRealReward(String reward) {
    final rewards = settingsBox.get("realRewards", defaultValue: <String>[]);
    rewards.add(reward);
    settingsBox.put("realRewards", rewards);
  }

  static List<String> getRealRewards() {
    return List<String>.from(settingsBox.get("realRewards", defaultValue: []));
  }

  static void updateRealReward(int index, String newValue) {
    final rewards = getRealRewards();
    if (index < 0 || index >= rewards.length) return;
    rewards[index] = newValue;
    settingsBox.put("realRewards", rewards);
  }

  static void deleteRealReward(int index) {
    final rewards = getRealRewards();
    if (index < 0 || index >= rewards.length) return;
    rewards.removeAt(index);
    settingsBox.put("realRewards", rewards);
  }

  static String? getRandomRealReward() {
    final rewards = getRealRewards();
    if (rewards.isEmpty) return null;
    final random = Random();
    return rewards[random.nextInt(rewards.length)];
  }

  // ---------------- Reset ----------------

  static Future<void> resetAll() async {
    await tasksBox.clear();
    await stickersBox.clear();
    await settingsBox.clear();
  }
}
