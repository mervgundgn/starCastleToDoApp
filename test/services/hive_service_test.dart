import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:starcastle_todoapp/models/task_model.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    await HiveService.init();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('Varsayılan haftalık görev eklenmeli', () async {
    final tasks = HiveService.getTasks();
    final exists = tasks.any((t) => t.isWeeklyAuto);
    expect(exists, true);
  });

  test('Görev eklenip tamamlanabilmeli', () async {
    final task = TaskModel(
      title: "Test Görev",
      category: "custom",
      period: "daily",
    );
    HiveService.addTask(task);

    expect(HiveService.getTasks().length, greaterThan(1)); // 1 default + yeni görev

    HiveService.completeTask(1); // default görev index 0
    final updated = HiveService.getTasks()[1];
    expect(updated.isCompleted, true);
  });
}
