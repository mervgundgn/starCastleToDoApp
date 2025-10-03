import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:starcastle_todoapp/features/parent/settings/edit_profile_screen.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../test_helper.dart';

void main() {
  setUp(() async {
    await setUpHiveTestEnv();
    await HiveService.settingsBox.put("childName", "Deneme");
    await HiveService.settingsBox.put("childAvatar", "icon_profile_boy.png");
  });

  tearDown(() async => await tearDownHiveTestEnv());

  testWidgets("EditProfileScreen shows save button", (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: EditProfileScreen()),
      ),
    );

    // Kaydet butonunu kontrol et
    expect(find.textContaining("Kaydet"), findsOneWidget);
  });
}
