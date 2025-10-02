import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  String? _error;

  Future<void> _changePin() async {
    final box = await Hive.openBox("settingsBox");
    final currentPin = box.get("parentPin", defaultValue: "1234");

    if (_oldPinController.text != currentPin) {
      setState(() => _error = "Eski PIN yanlış!");
      return;
    }
    if (_newPinController.text.length != 4) {
      setState(() => _error = "Yeni PIN 4 haneli olmalı!");
      return;
    }
    if (_newPinController.text != _confirmPinController.text) {
      setState(() => _error = "Yeni PIN tekrar girişi eşleşmiyor!");
      return;
    }

    await box.put("parentPin", _newPinController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN başarıyla değiştirildi ")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 Gradient arka plan
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE1BEE7), // pastel mor
              Color(0xFFF8BBD0), // pastel pembe
              Color(0xFFE3F2FD), // pastel mavi
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔹 Şeffaf AppBar benzeri üst kısım
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "PIN Değiştir",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 🔹 İçerik
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.deepPurple.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white.withOpacity(0.75),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "PIN Değiştir",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade400,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Eski PIN
                            _buildPinField(_oldPinController, "Eski PIN"),
                            const SizedBox(height: 16),

                            // Yeni PIN
                            _buildPinField(_newPinController, "Yeni PIN"),
                            const SizedBox(height: 16),

                            // Yeni PIN tekrar
                            _buildPinField(
                                _confirmPinController, "Yeni PIN (tekrar)"),
                            const SizedBox(height: 16),

                            if (_error != null)
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            const SizedBox(height: 20),

                            // Kaydet butonu
                            ElevatedButton(
                              onPressed: _changePin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9575CD),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadowColor: Colors.deepPurple.shade200,
                                elevation: 5,
                              ),
                              child: Text(
                                "PIN Güncelle",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Ortak PIN TextField
  Widget _buildPinField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      maxLength: 4,
      style: TextStyle(
        fontSize: 16,
        color: Colors.deepPurple.shade700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.deepPurple.shade400,
          fontWeight: FontWeight.w600,
        ),
        counterText: "",
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
