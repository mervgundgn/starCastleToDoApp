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
          "Tüm görevler, ödüller, ayarlar ve koleksiyonlar silinecek. Emin misiniz?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
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
        context.go("/child/home");
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
        title: 'Ödül Ekle',
        icon: 'assets/icons/icon_reward.png',
        route: '/parent/add-reward',
      ),
      _PanelItem(
        title: 'Ödülleri Yönet',
        icon: 'assets/icons/icon_reward.png',
        route: '/parent/manage-rewards',
      ),
      _PanelItem(
        title: 'Tüm Verileri Sıfırla',
        icon: 'assets/icons/icon_delete.png', // ✅ artık bu ikon kullanılacak
        route: 'reset',
        isReset: true,
      ),
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
                AppBar(
                  title: const Text("Ebeveyn Paneli"),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  foregroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go('/child/home'),
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
                      return _PanelCard(item: item, onReset: () => _confirmReset(context));
                    },
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

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.item, required this.onReset});

  final _PanelItem item;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.isReset) {
          onReset();
        } else {
          context.push(item.route);
        }
      },
      child: Card(
        color: item.isReset ? Colors.red.withOpacity(0.85) : Colors.white.withOpacity(0.85),
        elevation: 3,
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
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: item.isReset ? Colors.white : Colors.deepPurple,
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
    this.isReset = false,
  });

  final String title;
  final String icon;
  final String route;
  final bool isReset;
}
