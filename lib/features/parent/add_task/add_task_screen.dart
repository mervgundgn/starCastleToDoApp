import 'package:flutter/material.dart';
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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Yeni Görev Ekle"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Şato arka plan
          Image.asset(
            "assets/backgrounds/castle/bg_castle.png",
            fit: BoxFit.cover,
          ),

          // 🔹 İçerik
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
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
                            color: Colors.deepPurple.shade600,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
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
                      const SizedBox(height: 20),

                      // 🔹 Kategori seçimi
                      _buildDropdown<String>(
                        label: "Kategori seç",
                        value: _selectedCategory,
                        items: const [
                          DropdownMenuItem(
                              value: "flowers", child: Text("🌸 Çiçekler")),
                          DropdownMenuItem(
                              value: "cars", child: Text("🚗 Arabalar")),
                          DropdownMenuItem(
                              value: "princess", child: Text("👑 Prensesler")),
                          DropdownMenuItem(
                              value: "superheroes",
                              child: Text("🦸 Süper Kahramanlar")),
                          DropdownMenuItem(
                              value: "jobs", child: Text("👩‍🚀 Meslekler")),
                          DropdownMenuItem(
                              value: "custom", child: Text("⭐ Özel Görev")),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCategory = val);
                          }
                        },
                      ),

                      // 🔹 Görev tipi
                      _buildDropdown<String>(
                        label: "Görev tipi",
                        value: _selectedPeriod,
                        items: const [
                          DropdownMenuItem(
                              value: "daily", child: Text("🌞 Günlük")),
                          DropdownMenuItem(
                              value: "weekly", child: Text("📅 Haftalık")),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedPeriod = val);
                          }
                        },
                      ),

                      const SizedBox(height: 30),

                      // Kaydet butonu
                      ElevatedButton(
                        onPressed: _saveTask,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: AppColors.primaryBlue,
                        ),
                        child: Text(
                          "Kaydet",
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
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

  /// Ortak dropdown stil
  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.body.copyWith(
            color: Colors.deepPurple.shade600,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
        ),
        items: items,
        onChanged: onChanged,
        style: AppTextStyles.body.copyWith(
          color: Colors.deepPurple.shade700,
          fontSize: 16,
        ),
        dropdownColor: Colors.white.withOpacity(0.9),
        iconEnabledColor: Colors.purple.shade400,
      ),
    );
  }
}
