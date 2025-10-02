import 'package:hive/hive.dart';

part 'task_model.g.dart'; // build_runner ile üretilecek adapter

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String category;

  @HiveField(2)
  bool isCompleted;

  TaskModel({
    required this.title,
    required this.category,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? title,
    String? category,
    bool? isCompleted,
  }) {
    return TaskModel(
      title: title ?? this.title,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
