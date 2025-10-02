import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/task_model.dart';
import '../../../services/hive/hive_service.dart';

class ParentPanelScreen extends StatefulWidget {
  const ParentPanelScreen({super.key});

  @override
  State<ParentPanelScreen> createState() => _ParentPanelScreenState();
}

class _ParentPanelScreenState extends State<ParentPanelScreen> {
  late Box settingsBox;
  final TextEditingController _customTaskController = TextEditingController();

  final List<String> readyTasks = [
    "Diş fırçala",
    "Su iç",
    "Kitap oku",
    "Oyuncakları topla",
    "Erken uyu",
    "El yıka",
    "Sağlıklı beslen",
  ];

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box("settingsBox");
  }

  @override
  void dispose() {
    _customTaskController.dispose();
    super.dispose();
  }

  void _addTask(String title) {
    final task = TaskModel(
      title: title,
      category: "custom",
      isCompleted: false,
    );
    HiveService.addTask(task);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Görev eklendi: $title ✅")),
    );

    setState(() {});
  }

  void _openReports() {
    context.push("/parent/reports"); // main.dart'taki route ile uyumlu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralGrey,
      appBar: AppBar(
        title: const Text("Ebeveyn Paneli"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Hazır Görevler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: readyTasks
                  .map((task) => ElevatedButton(
                onPressed: () => _addTask(task),
                child: Text(task),
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            const Text(
              "Özel Görev Ekle",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customTaskController,
                    decoration: const InputDecoration(
                      hintText: "Görev girin",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_customTaskController.text.isNotEmpty) {
                      _addTask(_customTaskController.text);
                      _customTaskController.clear();
                    }
                  },
                  child: const Text("Ekle"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ PIN değiştir — route üzerinden ChangePinScreen'e gider
            ElevatedButton.icon(
              onPressed: () => context.push("/parent/change-pin"),
              icon: const Icon(Icons.lock),
              label: const Text("PIN Değiştir"),
            ),
            const SizedBox(height: 12),

            // Raporlar
            ElevatedButton.icon(
              onPressed: _openReports,
              icon: const Icon(Icons.bar_chart),
              label: const Text("Raporları Gör"),
            ),
          ],
        ),
      ),
    );
  }
}
