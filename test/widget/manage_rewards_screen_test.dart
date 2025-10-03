import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:starcastle_todoapp/features/parent/rewards/manage_rewards_screen.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';

import '../test_helper.dart';

void main() {
  setUp(() async {
    await setUpHiveTestEnv();
    await HiveService.settingsBox.put("realRewards", <String>[]);
  });

  tearDown(() async => await tearDownHiveTestEnv());

  testWidgets("ManageRewardsScreen has title and empty state", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ManageRewardsScreen()));

    // Başlık
    expect(find.textContaining("Ödül"), findsOneWidget);

    // Boş liste için info mesajı beklenebilir
    expect(find.textContaining("Henüz ödül ek"), findsOneWidget);
  });
}
