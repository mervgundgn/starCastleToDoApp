import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'services/crashlytics/crashlytics_service.dart';
import 'services/hive/hive_service.dart';
import 'firebase_options.dart';
import 'router/app_router.dart'; // ✅ Tek router dosyası

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await CrashlyticsService.init();
  } catch (e, s) {
    debugPrint("⚠️ Crashlytics init error: $e");
  }

  await Hive.initFlutter();

  // ❌ TEST: kutuları her açılışta silme (kaldırıldı)
  // await Hive.deleteBoxFromDisk('tasksBox');
  // await Hive.deleteBoxFromDisk('stickersBox');
  // await Hive.deleteBoxFromDisk('settingsBox');
  // debugPrint("🔥 Hive kutuları sıfırlandı (TEST)");

  await HiveService.init();

  runApp(const ProviderScope(child: StarCastleApp()));
}

class StarCastleApp extends StatelessWidget {
  const StarCastleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Star Castle: To Do App",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter, // ✅ Tek dosyadan alıyor
    );
  }
}
