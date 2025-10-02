import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starcastle_todoapp/features/parent/add_task/add_task_screen.dart';

void main() {
  testWidgets('Varsayılan haftalık görev eklenemesin', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddTaskScreen()));

    // TextField'a default görev yaz
    await tester.enterText(
        find.byType(TextField), "7 Günlük Görevleri Tamamlama");

    // Kaydet butonuna bas
    await tester.tap(find.text("Kaydet"));
    await tester.pump();

    // Snackbar mesajı kontrolü
    expect(find.text("Bu görev varsayılan olarak zaten mevcut ✅"),
        findsOneWidget);
  });
}
