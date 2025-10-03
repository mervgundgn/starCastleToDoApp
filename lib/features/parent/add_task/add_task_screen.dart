import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ GoRouter import
import '../../../models/task_model.dart';
import '../../../services/hive/hive_service.dart';
import '../../../core/constants/app_colors.dart';
import 'package:starcastle_todoapp/core/constants/app_text_styles.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  String _selectedCategory = "custom"; // Varsayılan özel görev
  String _selectedPeriod = "daily"; // Varsayılan günlük

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) return;

    // 🔹 Varsayılan haftalık görev tekrar eklenmesin
    if (_titleController.text.trim() == "7 Günlük Görevleri Tamamlama") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bu görev varsayılan olarak zaten mevcut ✅"),
        ),
      );
      return;
    }

    final task = TaskModel(
      title: _titleController.text.trim(),
      category: _selectedCategory,
      period: _selectedPeriod,
    );

    HiveService.addTask(task);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Görev eklendi: ${task.title} ✅")),
    );

    // ✅ Kaydedince ParentPanelScreen'e dön
    context.go('/parent/panel');
  }

  @override
  Widget build(BuildContext context) {
    final categories = {
      "flowers": "🌸 Çiçekler",
      "cars": "🚗 Arabalar",
      "princess": "👑 Prensesler",
      "superheroes": "🦸 Süper Kahramanlar",
      "jobs": "👩‍🚀 Meslekler",
      "custom": "⭐ Özel Görev",
    };

    final periods = {
      "daily": "🌞 Günlük",
      "weekly": "📅 Haftalık",
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Yeni Görev Ekle"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/parent/panel'), // ✅ geri dönüş
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Şato arka plan
          Image.asset(
            "assets/backgrounds/castle/bg_castle.png",
            fit: BoxFit.cover,
          ),

          // 🔹 Daha düşük parlak overlay
          Container(color: Colors.white.withOpacity(0.15)),

          // 🔹 İçerik
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: Colors.white.withOpacity(0.75),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Görev adı
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: "Görev adı",
                          labelStyle: AppTextStyles.body.copyWith(
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🔹 Kategori seçimi
                      const Text(
                        "Kategori seç",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.entries.map((entry) {
                          final key = entry.key;
                          final label = entry.value;
                          return ChoiceChip(
                            label: Text(label),
                            selected: _selectedCategory == key,
                            onSelected: (_) {
                              setState(() => _selectedCategory = key);
                            },
                            selectedColor: AppColors.pastelPurple,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // 🔹 Görev tipi seçimi
                      const Text(
                        "Görev tipi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        children: periods.entries.map((entry) {
                          final key = entry.key;
                          final label = entry.value;
                          return ChoiceChip(
                            label: Text(label),
                            selected: _selectedPeriod == key,
                            onSelected: (_) {
                              setState(() => _selectedPeriod = key);
                            },
                            selectedColor: AppColors.primaryBlue,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),

                      // Kaydet butonu (gradient pastel)
                      GestureDetector(
                        onTap: _saveTask,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryBlue.withOpacity(0.9),
                                AppColors.pastelPurple.withOpacity(0.9),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(2, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Kaydet",
                              style: AppTextStyles.heading.copyWith(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
