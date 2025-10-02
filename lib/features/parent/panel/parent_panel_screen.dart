import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ParentPanelScreen extends StatelessWidget {
  const ParentPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kart renkleri (pastel, çocuk-dostu)
    const _lavender = Color(0xFFEDE7FF);
    const _pink     = Color(0xFFFDE2F3);
    const _mint     = Color(0xFFE6FFF6);
    const _sunny    = Color(0xFFFFF6D8);

    // Metin rengi: koyu mor (yüksek kontrast yerine yumuşak)
    const _textColor = Color(0xFF3D2E69);

    final items = <_PanelItem>[
      _PanelItem(
        title: 'Görev Ekle',
        icon: 'assets/icons/icon_task_default.png',
        route: '/add-task',
        gradient: const [_pink, Colors.white],
      ),
      _PanelItem(
        title: 'Raporlar',
        icon: 'assets/icons/icon_progress.png',
        route: '/parent/reports',
        gradient: const [_sunny, Colors.white],
      ),
      _PanelItem(
        title: 'PIN Değiştir',
        icon: 'assets/icons/icon_settings.png',
        route: '/parent/change-pin',
        gradient: const [_mint, Colors.white],
      ),
      _PanelItem(
        title: 'Profil Düzenle',
        icon: 'assets/icons/edit_profile_icon.png',
        route: '/parent/edit-profile',
        gradient: const [_lavender, Colors.white],
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Ebeveyn Paneli'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Daha morumsu dreamy gradient 🌌
          gradient: LinearGradient(
            colors: [Color(0xFF6F4DD4), Color(0xFF8A63E6), Color(0xFFC6A7FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 32, 20, 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.92, // hizalamayı toparlar
          ),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            return _PanelCard(
              title: item.title,
              iconPath: item.icon,
              onTap: () => context.push(item.route),
              colors: item.gradient,
              textColor: _textColor,
            );
          },
        ),
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({
    required this.title,
    required this.iconPath,
    required this.onTap,
    required this.colors,
    required this.textColor,
  });

  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final List<Color> colors;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Büyük ikon (hata durumunda yedek ikon)
                SizedBox(
                  height: 72,
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 56,
                      color: Colors.black38,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor.withOpacity(0.92),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
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
    required this.gradient,
  });

  final String title;
  final String icon;
  final String route;
  final List<Color> gradient;
}
