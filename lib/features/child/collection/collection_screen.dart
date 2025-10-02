import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late Box stickersBox;

  final Map<String, String> albums = {
    "Prensesler": "assets/albums/princess/princess_cover.png",
    "Süper Kahramanlar": "assets/albums/superheroes/superhero_cover.png",
    "Çiçekler": "assets/albums/flowers/flower_cover.png",
    "Arabalar": "assets/albums/cars/car_cover.png",
    "Meslekler": "assets/albums/jobs/job_cover.png",
  };

  @override
  void initState() {
    super.initState();
    stickersBox = Hive.box("stickersBox");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: albums.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final title = albums.keys.elementAt(index);
            final cover = albums.values.elementAt(index);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AlbumDetailScreen(albumTitle: title),
                  ),
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        cover,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class AlbumDetailScreen extends StatelessWidget {
  final String albumTitle;
  const AlbumDetailScreen({super.key, required this.albumTitle});

  @override
  Widget build(BuildContext context) {
    final stickersBox = Hive.box("stickersBox");
    final stickers = stickersBox.get(albumTitle, defaultValue: <String>[]).cast<String>();

    return Scaffold(
      appBar: AppBar(
        title: Text(albumTitle),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stickers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final stickerPath = stickers[index];
          return Image.asset(
            stickerPath,
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
