import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PinService {
  static final _box = Hive.box("settingsBox");

  static const _pinKey = "parentPin";
  static const _failCountKey = "pinFailCount";
  static const _lockUntilKey = "pinLockUntil";

  /// Hash fonksiyonu
  static String _hashPin(String pin) {
    return sha256.convert(utf8.encode(pin)).toString();
  }

  /// Varsayılan PIN kaydet (1234)
  static Future<void> initDefaultPin() async {
    if (!_box.containsKey(_pinKey)) {
      await _box.put(_pinKey, _hashPin("1234"));
    }
  }

  /// PIN doğrulama
  static Future<bool> verifyPin(String pin) async {
    final lockUntil = _box.get(_lockUntilKey, defaultValue: 0);
    final now = DateTime.now().millisecondsSinceEpoch;

    // Halen kilitli mi?
    if (lockUntil > now) {
      return false; // kilitli
    }

    final storedHash = _box.get(_pinKey);
    if (storedHash == _hashPin(pin)) {
      // doğru → sayaç sıfırlansın
      await _box.put(_failCountKey, 0);
      return true;
    } else {
      // yanlış giriş
      final failCount = (_box.get(_failCountKey, defaultValue: 0) as int) + 1;
      await _box.put(_failCountKey, failCount);

      if (failCount >= 5) {
        // 30 saniye kilitle
        final lockUntil = now + (30 * 1000);
        await _box.put(_lockUntilKey, lockUntil);
        await _box.put(_failCountKey, 0);
      }
      return false;
    }
  }

  /// PIN değiştirme
  static Future<bool> changePin(String oldPin, String newPin) async {
    final storedHash = _box.get(_pinKey);
    if (storedHash == _hashPin(oldPin)) {
      await _box.put(_pinKey, _hashPin(newPin));
      return true;
    } else {
      return false;
    }
  }

  /// Kilit süresi (kullanıcıya mesaj göstermek için)
  static int remainingLockSeconds() {
    final lockUntil = _box.get(_lockUntilKey, defaultValue: 0);
    final now = DateTime.now().millisecondsSinceEpoch;
    final diff = (lockUntil - now) ~/ 1000;
    return diff > 0 ? diff : 0;
  }
}
