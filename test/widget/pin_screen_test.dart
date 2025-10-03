import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hive/hive.dart';

import 'package:starcastle_todoapp/features/parent/auth/pin_screen.dart';
import 'package:starcastle_todoapp/services/pin_service.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpTestHive();

    HiveService.settingsBox = await Hive.openBox("settingsBox");
    await HiveService.settingsBox.put("pin", "1234");
    await PinService.initDefaultPin();
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  testWidgets('PinScreen başlık ve input gösteriyor', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PinScreen()));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text("PIN Girişi"), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Yanlış PIN girilince hata mesajı gösteriliyor', (tester) async {
    await HiveService.settingsBox.clear();
    await HiveService.settingsBox.put("pin", "1234");

    await tester.pumpWidget(const MaterialApp(home: PinScreen()));
    await tester.pump(const Duration(milliseconds: 200));

    await tester.enterText(find.byType(TextField), "9999");
    await tester.tap(find.text("Giriş Yap"));

    // küçük pump kullan
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Hatalı PIN!"), findsOneWidget);
  });
}
