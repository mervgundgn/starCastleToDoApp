import 'package:flutter_test/flutter_test.dart';
import 'package:starcastle_todoapp/models/task_model.dart';

void main() {
  group("TaskModel Tests", () {
    test("TaskModel default values", () {
      final task = TaskModel(title: "Deneme", category: "cars");

      expect(task.title, "Deneme");
      expect(task.category, "cars");
      expect(task.isCompleted, false);
      expect(task.period, "daily");
      expect(task.isWeeklyAuto, false);
    });

    test("TaskModel copyWith works", () {
      final task = TaskModel(title: "A", category: "cars");
      final updated = task.copyWith(isCompleted: true);

      expect(updated.isCompleted, true);
      expect(updated.title, "A");
    });
  });
}
