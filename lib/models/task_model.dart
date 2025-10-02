import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String category;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  final String period; // 🔹 "daily" veya "weekly"

  TaskModel({
    required this.title,
    required this.category,
    this.isCompleted = false,
    this.period = "daily", // varsayılan günlük
  });

  TaskModel copyWith({
    String? title,
    String? category,
    bool? isCompleted,
    String? period,
  }) {
    return TaskModel(
      title: title ?? this.title,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      period: period ?? this.period,
    );
  }
}
