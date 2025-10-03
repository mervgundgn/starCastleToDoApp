import 'package:hive_test/hive_test.dart';
import 'package:hive/hive.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';
import 'package:starcastle_todoapp/models/task_model.dart';

/// Hive ortamını başlatır (test için)
Future<void> setUpHiveTestEnv() async {
  await setUpTestHive();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskModelAdapter());
  }

  HiveService.settingsBox = await Hive.openBox("settingsBox");
  HiveService.tasksBox = await Hive.openBox<TaskModel>("tasksBox");
  HiveService.stickersBox = await Hive.openBox("stickersBox");
}

/// Test sonrası ortamı temizler
Future<void> tearDownHiveTestEnv() async {
  await HiveService.settingsBox.close();
  await HiveService.tasksBox.close();
  await HiveService.stickersBox.close();

  await tearDownTestHive(); // hive_test’in kendi temizleme fonksiyonu
}
