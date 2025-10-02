import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tasks/tasks_screen.dart';
import '../collection/collection_screen.dart';
import '../profile/profile_screen.dart';

class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({super.key});

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    TasksScreen(),        // Görevler ekranı
    CollectionScreen(),   // Koleksiyon ekranı
    ProfileScreen(),      // Profil ekranı
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Şato arka plan
          Image.asset(
            "assets/backgrounds/castle/bg_castle.png",
            fit: BoxFit.cover,
          ),

          // 🔹 İçerik (seçili sayfa)
          SafeArea(child: _pages[_currentIndex]),
        ],
      ),

      // 🔹 Alt menü
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white.withOpacity(0.9),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/icons/icon_task_default.png")),
            label: "Görevler",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/icons/icon_collection.png")),
            label: "Koleksiyon",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/icons/icon_profile_boy.png")),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
