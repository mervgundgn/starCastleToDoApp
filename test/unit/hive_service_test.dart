import 'package:flutter_test/flutter_test.dart';
import 'package:starcastle_todoapp/models/task_model.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';

import '../test_helper.dart';

void main() {
  setUp(() async => await setUpHiveTestEnv());
  tearDown(() async => await tearDownHiveTestEnv());

  group("HiveService Görevler", () {
    test("Görev ekleme ve getirme", () {
      final task = TaskModel(title: "Test Görev", category: "custom");
      HiveService.addTask(task);

      final tasks = HiveService.getTasks();
      expect(tasks.length, 1);
      expect(tasks.first.title, "Test Görev");
    });

    test("Görev tamamlama", () {
      final task = TaskModel(title: "Tamamlanacak", category: "custom");
      HiveService.addTask(task);

      HiveService.completeTask(task); // ✅ TaskModel gönder

      final tasks = HiveService.getTasks();
      expect(tasks.first.isCompleted, true);
    });
  });

  group("HiveService Ödüller", () {
    test("Ödül ekleme ve rastgele ödül seçme", () {
      HiveService.addRealReward("Bisiklet");
      HiveService.addRealReward("Oyuncak");

      final rewards = HiveService.getRealRewards();
      expect(rewards.length, 2);

      final randomReward = HiveService.getRandomRealReward();
      expect(randomReward, isNotNull);
    });
  });
}
