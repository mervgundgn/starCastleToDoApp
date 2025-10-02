import 'package:flutter/material.dart';
import '../../../services/hive/hive_service.dart';
import '../../../core/widgets/info_banner.dart';

class ManageRewardsScreen extends StatefulWidget {
  const ManageRewardsScreen({super.key});

  @override
  State<ManageRewardsScreen> createState() => _ManageRewardsScreenState();
}

class _ManageRewardsScreenState extends State<ManageRewardsScreen> {
  late List<String> rewards;

  @override
  void initState() {
    super.initState();
    rewards = HiveService.getRealRewards();
  }

  void _deleteReward(int index) {
    HiveService.deleteRealReward(index);
    setState(() => rewards = HiveService.getRealRewards());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ödül silindi ✅")),
    );
  }

  void _editReward(int index) {
    final controller = TextEditingController(text: rewards[index]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ödülü Düzenle"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Yeni ödül adını girin",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Vazgeç"),
          ),
          TextButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                HiveService.updateRealReward(index, newValue);
                setState(() => rewards = HiveService.getRealRewards());
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ödül güncellendi: $newValue ✅")),
                );
              }
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasRewards = rewards.isNotEmpty;

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
                // 🔹 Özel AppBar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Ödülleri Yönet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 Liste veya Boş Durum
                Expanded(
                  child: hasRewards
                      ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      return Card(
                        color: Colors.white.withOpacity(0.85),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(
                            Icons.card_giftcard,
                            color: Colors.purple,
                            size: 30,
                          ),
                          title: Text(
                            reward,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blueAccent),
                                onPressed: () => _editReward(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () => _deleteReward(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : const Center(
                    child: InfoBanner(
                      text: "Henüz ödül eklenmemiş 🎁\nEbeveyn panelinden yeni ödül ekleyebilirsin.",
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
