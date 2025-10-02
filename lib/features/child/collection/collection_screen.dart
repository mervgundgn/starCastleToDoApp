import 'package:flutter/material.dart';
import '../../../services/hive/hive_service.dart';
import 'collection_detail_screen.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = {
      "princess": "Prensesler",
      "superheroes": "Süper Kahramanlar",
      "flowers": "Çiçekler",
      "cars": "Arabalar",
      "jobs": "Meslekler",
    };

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final key = categories.keys.elementAt(index);
          final name = categories.values.elementAt(index);

          // 🔹 Hive’den kategoriye ait sticker listesi al
          final stickers =
          HiveService.stickersBox.get(key, defaultValue: <String>[]) as List;
          final count = stickers.length;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CollectionDetailScreen(category: key, title: name),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("$count sticker"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
