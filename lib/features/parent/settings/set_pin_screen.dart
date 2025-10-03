import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/pin_service.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String errorMessage = "";

  Future<void> _savePin() async {
    final pin = _pinController.text.trim();
    final confirm = _confirmController.text.trim();

    if (pin.length != 4) {
      setState(() => errorMessage = "PIN 4 haneli olmalı!");
      return;
    }
    if (pin != confirm) {
      setState(() => errorMessage = "PIN tekrar girişi eşleşmiyor!");
      return;
    }

    await PinService.forceChangePin(pin);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PIN başarıyla oluşturuldu ✅")),
    );
    context.go('/parent/panel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Arka plan
          Image.asset("assets/backgrounds/castle/bg_castle.png", fit: BoxFit.cover),

          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "PIN Belirle",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 2)],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Card(
                        color: Colors.white.withOpacity(0.88),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildPinField(_pinController, "PIN"),
                              const SizedBox(height: 16),
                              _buildPinField(_confirmController, "PIN (tekrar)"),
                              const SizedBox(height: 12),
                              if (errorMessage.isNotEmpty)
                                Text(errorMessage, style: const TextStyle(color: Colors.red)),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _savePin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7E57C2),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: const Text("PIN Kaydet", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      maxLength: 4,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 12, color: Colors.deepPurple),
      decoration: InputDecoration(
        labelText: label,
        counterText: "",
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}
