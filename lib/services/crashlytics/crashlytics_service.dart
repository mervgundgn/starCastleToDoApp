import 'package:flutter/foundation.dart'; // FlutterError ve PlatformDispatcher burada
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  static Future<void> init() async {
    // Crashlytics otomatik hata kaydı
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    // Uncaught exceptions (örn. async kodlar)
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }

  static void recordError(dynamic exception, StackTrace? stack) {
    FirebaseCrashlytics.instance.recordError(exception, stack);
  }
}
