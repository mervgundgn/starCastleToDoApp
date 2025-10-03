import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ GoRouter import
import '../../../services/hive/hive_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String selectedAvatar = "icon_profile_boy.png";
  String message = "";

  @override
  void initState() {
    super.initState();
    final box = HiveService.settingsBox;
    _nameController.text = box.get("childName", defaultValue: "");
    selectedAvatar =
        box.get("childAvatar", defaultValue: "icon_profile_boy.png");
  }

  Future<void> _saveProfile() async {
    final box = HiveService.settingsBox;
    await box.put("childName", _nameController.text);
    await box.put("childAvatar", selectedAvatar);

    setState(() => message = "Profil güncellendi ✅");

    // ✅ Kaydedince ParentPanelScreen'e dön
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) context.go('/parent/panel');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatars = [
      "icon_profile_boy.png",
      "icon_profile_girl.png",
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/backgrounds/castle/bg_castle.png",
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                // 🔹 Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => context.go('/parent/panel'), // ✅ GoRouter
                    ),
                    const Text(
                      "Profilimi Düzenle",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 İçerik
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Çocuk Adı
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: "Çocuk Adı",
                            labelStyle: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Avatar Seçimi
                        const Text(
                          "Avatar Seç",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: avatars.map((avatar) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedAvatar = avatar),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedAvatar == avatar
                                        ? Colors.deepPurple
                                        : Colors.grey.shade400,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white.withOpacity(0.85),
                                  boxShadow: selectedAvatar == avatar
                                      ? [
                                    BoxShadow(
                                      color: Colors.purple.shade200,
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    )
                                  ]
                                      : [],
                                ),
                                child: Image.asset(
                                  "assets/icons/$avatar",
                                  height: 90,
                                  errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.person, size: 70),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),

                        if (message.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              message,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // 🔹 Kaydet butonu sabit altta
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF7E57C2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      shadowColor: Colors.deepPurple.shade200,
                    ),
                    child: const Text(
                      "Kaydet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
}
