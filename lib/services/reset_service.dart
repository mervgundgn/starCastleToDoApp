import 'package:hive_flutter/hive_flutter.dart';

class ResetService {
  static Future<void> resetAllData() async {
    await Hive.box("tasksBox").clear();
    await Hive.box("stickersBox").clear();
    await Hive.box("settingsBox").clear();
  }
}
