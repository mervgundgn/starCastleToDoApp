import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Box stickersBox;
  late Box settingsBox;

  @override
  void initState() {
    super.initState();
    stickersBox = Hive.box("stickersBox");
    settingsBox = Hive.box("settingsBox");
  }

  @override
  Widget build(BuildContext context) {
    final childName = settingsBox.get("childName", defaultValue: "Çocuğum");
    final avatar = settingsBox.get("avatar", defaultValue: "assets/icons/icon_profile_boy.png");

    // 🔹 Tüm sticker sayısını hesapla
    int totalStickers = 0;
    for (var key in stickersBox.keys) {
      final list = stickersBox.get(key, defaultValue: <String>[]) as List;
      totalStickers += list.length.toInt();
    }

    final progress = (totalStickers / 100).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 24),

              // 🔹 Avatar
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(avatar),
              ),
              const SizedBox(height: 12),

              // 🔹 İsim
              Text(
                childName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Sticker sayısı
              Text(
                "Toplam Sticker: $totalStickers",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              // 🔹 İlerleme barı
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 16,
                  backgroundColor: AppColors.neutralGrey,
                  color: AppColors.sunnyYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(height: 8),
              Text("%${(progress * 100).toInt()} tamamlandı"),

              const SizedBox(height: 32),

              // 🔹 Ebeveyn Paneli butonu
              ElevatedButton.icon(
                onPressed: () => context.push('/parent/pin'),
                icon: const Icon(Icons.lock),
                label: const Text("Ebeveyn Paneli"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
