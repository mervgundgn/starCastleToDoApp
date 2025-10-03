import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hive/hive.dart';

import 'package:starcastle_todoapp/features/child/collection/collection_screen.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';

void main() {
  setUp(() async {
    await setUpTestHive();

    HiveService.settingsBox = await Hive.openBox("settingsBox");
    HiveService.tasksBox = await Hive.openBox("tasksBox");
    HiveService.stickersBox = await Hive.openBox("stickersBox");

    // Koleksiyon ekranı hata vermesin diye örnek bir kategori ekleyelim
    await HiveService.stickersBox.put("princess", <String>[]);
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  testWidgets("CollectionScreen renders title", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CollectionScreen()));

    // Başlıkta "Koleksiyon" kelimesi geçiyor mu
    expect(find.textContaining("Koleksiyon"), findsOneWidget);
  });
}
