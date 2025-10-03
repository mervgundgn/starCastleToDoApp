import 'package:flutter/material.dart';
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
    TasksScreen(), // Görevler ekranı
    CollectionScreen(), // Koleksiyon ekranı
    ProfileScreen(), // Profil ekranı
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

          // 🔹 Hafif parlak overlay
          Container(color: Colors.white.withOpacity(0.22)),

          // 🔹 İçerik
          SafeArea(
            child: _pages[_currentIndex],
          ),
        ],
      ),

      // 🔹 Alt menü
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.black54,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
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
      ),
    );
  }
}
