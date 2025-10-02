import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/child/home/home_screen.dart';
import 'features/parent/auth/pin_screen.dart';
import 'features/parent/panel/parent_panel_screen.dart';
import 'features/parent/reports/reports_screen.dart';
import 'features/parent/settings/change_pin_screen.dart';
import 'services/crashlytics/crashlytics_service.dart';
import 'services/hive/hive_service.dart';
import 'firebase_options.dart';

// 🌍 Router global tanım
final appRouter = GoRouter(
  initialLocation: "/splash",
  routes: [
    GoRoute(
      path: "/splash",
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: "/child/home",
      builder: (context, state) => const ChildHomeScreen(),
    ),
    GoRoute(
      path: "/parent/pin",
      builder: (context, state) => const PinScreen(),
    ),
    GoRoute(
      path: "/parent/panel",
      builder: (context, state) => const ParentPanelScreen(),
    ),
    GoRoute(
      path: "/parent/reports",
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: "/parent/change-pin",
      builder: (context, state) => const ChangePinScreen(),
    ),
  ],
);

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

  // 📌 TEST: Her açılışta verileri sıfırla (önce sil, sonra init et)
  await Hive.deleteBoxFromDisk('tasksBox');
  await Hive.deleteBoxFromDisk('stickersBox');
  await Hive.deleteBoxFromDisk('settingsBox');
  debugPrint("🔥 Hive kutuları sıfırlandı (TEST)");

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
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
      ],
    );
  }
}
