import 'package:flutter/material.dart';
import '../../../services/pin_service.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  String errorMessage = "";

  Future<void> _changePin() async {
    final oldPin = _oldPinController.text.trim();
    final newPin = _newPinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    if (newPin.length != 4) {
      setState(() => errorMessage = "Yeni PIN 4 haneli olmalı!");
      return;
    }
    if (newPin != confirmPin) {
      setState(() => errorMessage = "Yeni PIN tekrar girişi eşleşmiyor!");
      return;
    }

    final success = await PinService.changePin(oldPin, newPin);
    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN başarıyla değiştirildi ✅")),
      );
      Navigator.pop(context);
    } else {
      setState(() => errorMessage = "Eski PIN yanlış!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Arka plan görseli
          Image.asset(
            "assets/backgrounds/castle/bg_castle.png",
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                // 🔹 Üst kısım (AppBar yerine custom header)
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
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 İçerik
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPinField(_oldPinController, "Eski PIN"),
                          const SizedBox(height: 16),
                          _buildPinField(_newPinController, "Yeni PIN"),
                          const SizedBox(height: 16),
                          _buildPinField(_confirmPinController, "Yeni PIN (tekrar)"),

                          const SizedBox(height: 12),
                          if (errorMessage.isNotEmpty)
                            Text(errorMessage, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: _changePin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7E57C2),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 5,
                              shadowColor: Colors.deepPurple.shade200,
                            ),
                            child: const Text(
                              "PIN Güncelle",
                              style: TextStyle(
                                color: Colors.white,
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
              ],
            ),
          ),
        ],
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
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.w600,
        ),
        counterText: "",
        filled: true,
        fillColor: Colors.white.withOpacity(0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
