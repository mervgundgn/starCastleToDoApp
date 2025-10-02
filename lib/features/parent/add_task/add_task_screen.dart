import 'package:flutter/material.dart';
import '../../../models/task_model.dart';
import '../../../services/hive/hive_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  String _selectedCategory = "custom"; // Varsayılan özel görev
  String _selectedPeriod = "daily";    // Varsayılan günlük

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) return;

    final task = TaskModel(
      title: _titleController.text.trim(),
      category: _selectedCategory,
      period: _selectedPeriod,
    );

    HiveService.addTask(task);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Görev eklendi: ${task.title} ✅")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Görev Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Görev adı
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Görev adı",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Kategori seçimi
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: const [
                DropdownMenuItem(value: "flowers", child: Text("Çiçekler")),
                DropdownMenuItem(value: "cars", child: Text("Arabalar")),
                DropdownMenuItem(value: "princess", child: Text("Prensesler")),
                DropdownMenuItem(value: "superheroes", child: Text("Süper Kahramanlar")),
                DropdownMenuItem(value: "jobs", child: Text("Meslekler")),
                DropdownMenuItem(value: "custom", child: Text("Özel Görev")),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
              decoration: const InputDecoration(
                labelText: "Kategori seç",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Görev tipi (daily / weekly)
            DropdownButtonFormField<String>(
              value: _selectedPeriod,
              items: const [
                DropdownMenuItem(value: "daily", child: Text("Günlük")),
                DropdownMenuItem(value: "weekly", child: Text("Haftalık")),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedPeriod = val);
              },
              decoration: const InputDecoration(
                labelText: "Görev Tipi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Kaydet butonu
            ElevatedButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save),
              label: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
