import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:starcastle_todoapp/features/parent/add_task/add_task_screen.dart';

import '../test_helper.dart';

void main() {
  setUp(() async => await setUpHiveTestEnv());
  tearDown(() async => await tearDownHiveTestEnv());

  testWidgets("AddTaskScreen has title and save button", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AddTaskScreen(),
        ),
      ),
    );

    // Başlık ve buton kontrolü
    expect(find.textContaining("Görev Ekle"), findsOneWidget); // esnek eşleşme
    expect(find.text("Kaydet"), findsOneWidget);
  });
}
