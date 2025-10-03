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
    final avatar =
    settingsBox.get("avatar", defaultValue: "assets/icons/icon_profile_boy.png");

    // 🔹 Tüm sticker sayısını hesapla
    int totalStickers = 0;
    for (var key in stickersBox.keys) {
      final list = stickersBox.get(key, defaultValue: <String>[]) as List;
      totalStickers += list.length.toInt();
    }

    final progress = (totalStickers / 100).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/backgrounds/castle/bg_castle.png", fit: BoxFit.cover),
          SafeArea(
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
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 2)
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 Yan yana kutular
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          title: "Toplam Sticker",
                          value: totalStickers.toString(),
                          icon: Icons.star,
                          color: AppColors.sunnyYellow,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          title: "Tamamlanma",
                          value: "%${(progress * 100).toInt()}",
                          icon: Icons.bar_chart,
                          color: AppColors.primaryBlue,
                          progress: progress,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 🔹 Ebeveyn Paneli butonu
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/parent/pin'),
                    icon: const Icon(Icons.lock, color: Colors.white),
                    label: const Text("Ebeveyn Paneli"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: AppColors.pastelPurple,
                      foregroundColor: Colors.white,
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    double? progress,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (progress != null) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                color: color,
                backgroundColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
