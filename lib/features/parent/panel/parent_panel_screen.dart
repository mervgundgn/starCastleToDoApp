import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/reset_service.dart';

class ParentPanelScreen extends StatelessWidget {
  const ParentPanelScreen({super.key});

  Future<void> _confirmReset(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Verileri Sıfırla"),
        content: const Text(
          "Tüm görevler, ödüller, ayarlar ve koleksiyonlar silinecek.\n\n"
              "Bu işlem geri alınamaz. Emin misiniz?",
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false), // ✅ GoRouter pop
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () => context.pop(true), // ✅ GoRouter pop
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Evet, Sıfırla"),
          ),
        ],
      ),
    );

    if (result == true) {
      await ResetService.resetAllData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tüm veriler silindi ✅")),
        );
        context.go("/child/home"); // ✅ çocuk ana sayfaya yönlendir
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <_PanelItem>[
      _PanelItem(
        title: 'Görev Ekle',
        icon: 'assets/icons/icon_task_default.png',
        route: '/add-task',
      ),
      _PanelItem(
        title: 'Raporlar',
        icon: 'assets/icons/icon_progress.png',
        route: '/parent/reports',
      ),
      _PanelItem(
        title: 'PIN Değiştir',
        icon: 'assets/icons/icon_settings.png',
        route: '/parent/change-pin',
      ),
      _PanelItem(
        title: 'Profil Düzenle',
        icon: 'assets/icons/edit_profile_icon.png',
        route: '/parent/edit-profile',
      ),
      _PanelItem(
        title: 'Ödülleri Yönet',
        icon: 'assets/icons/icon_reward.png',
        route: '/parent/manage-rewards',
      ),
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/backgrounds/castle/bg_castle.png", fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: const Text("Ebeveyn Paneli"),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  foregroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go('/child/home'), // ✅ GoRouter
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return _PanelCard(item: item);
                    },
                  ),
                ),
                // 🔹 Reset butonu
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () => _confirmReset(context),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red.shade700.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.redAccent, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.lock, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Tüm Verileri Sıfırla",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.item});

  final _PanelItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.go(item.route), // ✅ GoRouter navigation
      child: Card(
        color: Colors.white.withOpacity(0.85),
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              item.icon,
              width: 50,
              height: 50,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.help_outline,
                size: 50,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelItem {
  const _PanelItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final String icon;
  final String route;
}
