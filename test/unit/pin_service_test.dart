import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:starcastle_todoapp/services/pin_service.dart';
import 'package:starcastle_todoapp/services/hive/hive_service.dart';

void main() {
  group('PinService Unit Tests', () {
    late Directory tempDir;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Hive için geçici dizin
      tempDir = Directory.systemTemp.createTempSync();
      Hive.init(tempDir.path);

      HiveService.settingsBox = await Hive.openBox("settingsBox");
      await PinService.initDefaultPin();
    });

    tearDownAll(() async {
      await HiveService.settingsBox.clear();
      await Hive.close();
      tempDir.deleteSync(recursive: true);
    });

    test('Başlangıçta pin yoksa null olmalı', () async {
      final hasPin = await PinService.hasPin();
      expect(hasPin, false);
    });

    test('Yeni pin kaydedilebilir', () async {
      await PinService.forceChangePin("1234");
      final ok = await PinService.verifyPin("1234");
      expect(ok, true);
    });

    test('Yanlış pin doğrulamada false dönmeli', () async {
      final ok = await PinService.verifyPin("9999");
      expect(ok, false);
    });

    test('Kilit mekanizması çalışıyor mu', () async {
      await PinService.lockForSeconds(1);
      final remaining = await PinService.remainingLockSeconds();
      expect(remaining > 0, true);
    });
  });
}
