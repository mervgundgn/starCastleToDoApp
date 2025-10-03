import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/pin_service.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String errorMessage = "";

  Future<void> _changePin() async {
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

    await PinService.forceChangePin(newPin);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PIN başarıyla değiştirildi ✅")),
    );
    context.go('/parent/panel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("PIN Değiştir"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/parent/panel'),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/backgrounds/castle/bg_castle.png",
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Center( // 🔹 Ortalamak için Center
              child: Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 🔹 İçeriğe göre küçül
                    children: [
                      _buildPinField(_newPinController, "Yeni PIN"),
                      const SizedBox(height: 16),
                      _buildPinField(_confirmPinController, "Yeni PIN (tekrar)"),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _changePin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7E57C2),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "PIN Güncelle",
                          style: TextStyle(color: Colors.white),
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

  Widget _buildPinField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: true,
      maxLength: 4,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, counterText: ""),
    );
  }
}
