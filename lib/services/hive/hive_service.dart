import 'package:hive_flutter/hive_flutter.dart';
import '../../models/task_model.dart';

class HiveService {
  // Kutular
  static late Box<TaskModel> tasksBox;
  static late Box<dynamic> stickersBox; // ✅ dynamic olacak
  static late Box settingsBox;

  /// Hive başlatma
  static Future<void> init() async {
    // Adapter kaydı (sadece 1 kez yapılmalı)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }

    // 🗃 Kutular (önce kontrol et, sonra aç)
    if (!Hive.isBoxOpen('tasksBox')) {
      tasksBox = await Hive.openBox<TaskModel>('tasksBox');
    } else {
      tasksBox = Hive.box<TaskModel>('tasksBox');
    }

    if (!Hive.isBoxOpen('stickersBox')) {
      stickersBox = await Hive.openBox<dynamic>('stickersBox'); // ✅
    } else {
      stickersBox = Hive.box<dynamic>('stickersBox'); // ✅
    }

    if (!Hive.isBoxOpen('settingsBox')) {
      settingsBox = await Hive.openBox('settingsBox');
    } else {
      settingsBox = Hive.box('settingsBox');
    }
  }

  // ---------------------------
  // Görevler
  // ---------------------------

  static void addTask(TaskModel task) {
    tasksBox.add(task);
  }

  static List<TaskModel> getTasks() {
    return tasksBox.values.toList();
  }

  static void completeTask(int index) {
    final task = tasksBox.getAt(index);
    if (task != null) {
      task.isCompleted = true;
      task.save();
    }
  }

  // ---------------------------
  // Stickerlar
  // ---------------------------

  static String addRandomSticker(String category) {
    final stickers = (stickersBox.get(category, defaultValue: <String>[]) as List).cast<String>();

    final limits = {
      "princess": 20,
      "superheroes": 20,
      "flowers": 20,
      "cars": 20,
      "jobs": 10,
    };

    final prefixes = {
      "princess": "princess",
      "superheroes": "superhero",
      "flowers": "flower",
      "cars": "car",
      "jobs": "job",
    };

    final total = limits[category] ?? 0;
    if (stickers.length >= total) return stickers.last;

    final nextIndex = stickers.length + 1;
    final prefix = prefixes[category] ?? category;

    // 🔹 Örn: flower_01, car_02
    final newSticker = "${prefix}_${nextIndex.toString().padLeft(2, '0')}";

    stickers.add(newSticker);
    stickersBox.put(category, stickers);

    return newSticker;
  }

  static bool isCategoryComplete(String category) {
    final stickers = (stickersBox.get(category, defaultValue: <String>[]) as List).cast<String>();
    final limits = {
      "princess": 20,
      "superheroes": 20,
      "flowers": 20,
      "cars": 20,
      "jobs": 10,
    };
    return stickers.length >= (limits[category] ?? 0);
  }
}
