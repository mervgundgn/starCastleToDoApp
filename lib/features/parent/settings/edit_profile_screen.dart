import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/hive/hive_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String selectedAvatar = "icon_profile_default.png";
  String message = "";

  @override
  void initState() {
    super.initState();
    final box = HiveService.settingsBox;
    _nameController.text = box.get("childName", defaultValue: "");
    selectedAvatar = box.get("childAvatar", defaultValue: "icon_profile_default.png");
  }

  Future<void> _saveProfile() async {
    final box = HiveService.settingsBox;
    await box.put("childName", _nameController.text);
    await box.put("childAvatar", selectedAvatar);
    setState(() => message = "Profil güncellendi");
  }

  @override
  Widget build(BuildContext context) {
    final avatars = [
      "icon_profile_boy.png",
      "icon_profile_girl.png",
      "icon_profile_default.png",
    ];

    return Scaffold(
      // 🔹 Pastel dreamy arka plan
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE1BEE7), // pastel mor
              Color(0xFFF8BBD0), // pastel pembe
              Color(0xFFE3F2FD), // pastel mavi
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔹 Şeffaf AppBar tarzı
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Profilimi Düzenle",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Card(
                      elevation: 6,
                      shadowColor: Colors.deepPurple.shade100,
                      color: Colors.white.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // 🔹 Çocuk Adı TextField
                            TextField(
                              controller: _nameController,
                              style: TextStyle(
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: "Çocuk Adı",
                                labelStyle: TextStyle(
                                  color: Colors.deepPurple.shade400,
                                  fontWeight: FontWeight.w600,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.7),
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

                            // 🔹 Avatar seçimi
                            Text(
                              "Avatar Seç",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade400,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: avatars.map((avatar) {
                                return GestureDetector(
                                  onTap: () => setState(() => selectedAvatar = avatar),
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
                                      color: Colors.white.withOpacity(0.7),
                                      boxShadow: selectedAvatar == avatar
                                          ? [
                                        BoxShadow(
                                          color: Colors.purple.shade100,
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                        )
                                      ]
                                          : [],
                                    ),
                                    child: Image.asset(
                                      "assets/icons/$avatar",
                                      height: 60,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            // 🔹 Kaydet butonu
                            ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: const Color(0xFF9575CD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                shadowColor: Colors.deepPurple.shade200,
                                elevation: 5,
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
                            const SizedBox(height: 12),

                            if (message.isNotEmpty)
                              Text(
                                message,
                                style: TextStyle(
                                  color: message.contains("")
                                      ? Colors.green.shade700
                                      : Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
