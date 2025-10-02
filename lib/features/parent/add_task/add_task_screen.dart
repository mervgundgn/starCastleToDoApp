import 'package:flutter/material.dart';
import '../../../services/hive/hive_service.dart';
import '../../../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  String _selectedCategory = "flowers";

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

            // Kategori seçimi
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: "Kategori seç",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "flowers", child: Text("Çiçekler")),
                DropdownMenuItem(value: "cars", child: Text("Arabalar")),
                DropdownMenuItem(value: "princess", child: Text("Prensesler")),
                DropdownMenuItem(value: "superheroes", child: Text("Süper Kahramanlar")),
                DropdownMenuItem(value: "jobs", child: Text("Meslekler")),
              ],
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            const SizedBox(height: 24),

            // Kaydet butonu
            ElevatedButton.icon(
              onPressed: () {
                if (_titleController.text.trim().isEmpty) return;

                final task = TaskModel(
                  title: _titleController.text.trim(),
                  category: _selectedCategory,
                );
                HiveService.addTask(task);

                Navigator.pop(context); // geri dön
              },
              icon: const Icon(Icons.add),
              label: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
