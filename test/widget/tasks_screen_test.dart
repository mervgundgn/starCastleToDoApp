import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:starcastle_todoapp/features/child/tasks/tasks_screen.dart';

import '../test_helper.dart';

void main() {
  setUp(() async => await setUpHiveTestEnv());
  tearDown(() async => await tearDownHiveTestEnv());

  testWidgets("TasksScreen renders correctly with no tasks", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TasksScreen()));

    // Başlık
    expect(find.text("Görevler"), findsOneWidget);

    // Boş mesaj (parça eşleşme)
    expect(find.textContaining("Henüz günlük görev yok"), findsOneWidget);
    expect(find.textContaining("Ebeveyn panelinden"), findsOneWidget);
  });
}
