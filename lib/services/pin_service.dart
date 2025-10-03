import 'package:hive/hive.dart';
import 'hive/hive_service.dart';

class PinService {
  static const _pinKey = "pin";
  static const _lockKey = "lockUntil";

  /// Varsayılan PIN oluşturma (1234 yok artık, null bırakıyoruz)
  static Future<void> initDefaultPin() async {
    if (HiveService.settingsBox == null || !HiveService.settingsBox.isOpen) {
      HiveService.settingsBox = await Hive.openBox("settingsBox");
    }
    final box = HiveService.settingsBox;

    if (!box.containsKey(_pinKey)) {
      await box.put(_pinKey, null);
    }
  }

  /// PIN var mı kontrolü
  static Future<bool> hasPin() async {
    final box = HiveService.settingsBox;
    final pin = box.get(_pinKey);
    return pin != null && pin.toString().isNotEmpty;
  }

  /// PIN doğrulama
  static Future<bool> verifyPin(String pin) async {
    final box = HiveService.settingsBox;
    return box.get(_pinKey) == pin;
  }

  /// PIN değiştirme (kontrolsüz)
  static Future<void> forceChangePin(String newPin) async {
    final box = HiveService.settingsBox;
    await box.put(_pinKey, newPin);
  }

  /// Yanlış PIN girişinde kilit süresi başlat
  static Future<void> lockForSeconds(int seconds) async {
    final until = DateTime.now().millisecondsSinceEpoch + (seconds * 1000);
    await HiveService.settingsBox.put(_lockKey, until);
  }

  /// Kilit açılmasına kalan süre
  static Future<int> remainingLockSeconds() async {
    final until = HiveService.settingsBox.get(_lockKey, defaultValue: 0);
    final now = DateTime.now().millisecondsSinceEpoch;
    if (until == 0 || now >= until) {
      return 0;
    }
    return ((until - now) / 1000).ceil();
  }
}
