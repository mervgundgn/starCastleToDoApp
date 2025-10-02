import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starcastle_todoapp/features/child/tasks/tasks_screen.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    await HiveService.init();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  testWidgets('Varsayılan haftalık görev listelenmeli', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TasksScreen()));

    // Günlük tab default açık → Haftalık tab’a geç
    await tester.tap(find.text("Haftalık"));
    await tester.pumpAndSettle();

    // Varsayılan haftalık görev görünmeli
    expect(find.text("7 Günlük Görevleri Tamamlama"), findsOneWidget);
  });

  testWidgets('Haftalık görev özel ikonla gösterilmeli', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TasksScreen()));

    // Haftalık sekmeye geç
    await tester.tap(find.text("Haftalık"));
    await tester.pumpAndSettle();

    // Özel ikon (⭐) görünüyor mu?
    expect(find.byIcon(Icons.star), findsWidgets);
  });
}
