import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:starcastle_todoapp/features/child/profile/profile_screen.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';
import '../test_helper.dart';

void main() {
  setUp(() async {
    await setUpHiveTestEnv();
    await HiveService.settingsBox.put("childName", "Çocuğum");
  });

  tearDown(() async => await tearDownHiveTestEnv());

  testWidgets("ProfileScreen shows child profile and parent button", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    // AppBar'da "Çocuğum" görünüyor mu?
    expect(find.text("Çocuğum"), findsOneWidget);

    // "Ebeveyn Paneli" butonu görünüyor mu?
    expect(find.textContaining("Ebeveyn"), findsOneWidget);
  });
}
