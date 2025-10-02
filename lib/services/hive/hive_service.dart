import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/task_model.dart';

class HiveService {
  // Kutular
  static late Box<TaskModel> tasksBox;
  static late Box<dynamic> stickersBox;
  static late Box settingsBox;

  /// Hive başlatma
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

      // Tamamlanan göreve sticker ver
      addRandomSticker();
    }
  }

  // ---------------------------
  // Stickerlar (tam random)
  // ---------------------------

  static String addRandomSticker() {
    final random = Random();

    // Kategoriler ve limitler
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

    // Rastgele kategori seç
    final categories = limits.keys.toList();
    final category = categories[random.nextInt(categories.length)];

    // Rastgele index seç
    final total = limits[category]!;
    final index = random.nextInt(total) + 1;

    final prefix = prefixes[category]!;
    final sticker = "${prefix}_${index.toString().padLeft(2, '0')}";

    print("🎁 Sticker verildi: $sticker (kategori: $category)");

    // Geriye path dön → UI’de kolay kullanım
    return "$category/$sticker";
  }

  // ---------------------------
  // Debug amaçlı reset
  // ---------------------------

  static Future<void> resetAll() async {
    await tasksBox.clear();
    await stickersBox.clear();
    await settingsBox.clear();
  }
}
