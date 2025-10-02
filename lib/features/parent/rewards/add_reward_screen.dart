import 'package:flutter/material.dart';
import '../../../services/hive/hive_service.dart';

class AddRewardScreen extends StatefulWidget {
  const AddRewardScreen({super.key});

  @override
  State<AddRewardScreen> createState() => _AddRewardScreenState();
}

class _AddRewardScreenState extends State<AddRewardScreen> {
  final _rewardController = TextEditingController();
  String? _selectedIcon;

  final icons = {
    "🎁": Icons.card_giftcard,
    "🍭": Icons.cake,
    "🧸": Icons.toys,
    "🚲": Icons.pedal_bike,
    "🎮": Icons.videogame_asset,
  };

  @override
  void dispose() {
    _rewardController.dispose();
    super.dispose();
  }

  void _saveReward() {
    final reward = _rewardController.text.trim();
    if (reward.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen ödül adı giriniz ❌")),
      );
      return;
    }

    HiveService.addRealReward(reward);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ödül eklendi: $reward ✅")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/backgrounds/castle/bg_castle.png", fit: BoxFit.cover),

          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Gerçek Ödül Ekle",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black54, offset: Offset(1,1), blurRadius: 2)],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _rewardController,
                          decoration: InputDecoration(
                            hintText: "Örn: Oyuncak, Parka Gitme, Dışarıda Yemek",
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text("İkon seç:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 12,
                          children: icons.entries.map((entry) {
                            return ChoiceChip(
                              label: Text(entry.key, style: const TextStyle(fontSize: 20)),
                              selected: _selectedIcon == entry.key,
                              onSelected: (_) {
                                setState(() => _selectedIcon = entry.key);
                              },
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: _saveReward,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF7E57C2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Kaydet",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ],
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
