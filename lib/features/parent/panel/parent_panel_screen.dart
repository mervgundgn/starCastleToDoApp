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

  String _selectedTaskType = "daily"; // 🔹 Günlük / Haftalık seçimi

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
      period: _selectedTaskType, // ✅ modeldeki alan
    );
    HiveService.addTask(task);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Görev eklendi: $title ($_selectedTaskType) ✅")),
    );

    setState(() {});
  }

  void _openReports() {
    context.push("/parent/reports");
  }

  Future<void> _resetData() async {
    await Hive.box('tasksBox').clear();
    await Hive.box('stickersBox').clear();
    await Hive.box('settingsBox').clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tüm veriler temizlendi ✅")),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralGrey,
      appBar: AppBar(title: const Text("Ebeveyn Paneli")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 🔹 Görev Tipi Seç
            const Text("Görev Tipi Seç", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _selectedTaskType,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: "daily", child: Text("Günlük Görev")),
                DropdownMenuItem(value: "weekly", child: Text("Haftalık Görev")),
              ],
              onChanged: (value) => setState(() => _selectedTaskType = value!),
            ),
            const SizedBox(height: 20),

            // 🔹 Hazır Görevler
            const Text("Hazır Görevler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

            // 🔹 Özel Görev Ekle
            const Text("Özel Görev Ekle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

            // 🔹 PIN değiştir
            ElevatedButton.icon(
              onPressed: () => context.push("/parent/change-pin"),
              icon: const Icon(Icons.lock),
              label: const Text("PIN Değiştir"),
            ),
            const SizedBox(height: 12),

            // 🔹 Raporlar
            ElevatedButton.icon(
              onPressed: _openReports,
              icon: const Icon(Icons.bar_chart),
              label: const Text("Raporları Gör"),
            ),
            const SizedBox(height: 20),

            // 🔹 Verileri sıfırlama
            ElevatedButton.icon(
              onPressed: _resetData,
              icon: const Icon(Icons.delete_forever),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              label: const Text("Tüm Verileri Sıfırla"),
            ),
          ],
        ),
      ),
    );
  }
}
