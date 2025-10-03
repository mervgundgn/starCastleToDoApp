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
      appBar: AppBar(title: const Text("PIN Belirle")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "PIN"),
            ),
            TextField(
              controller: _confirmController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "PIN Tekrar"),
            ),
            const SizedBox(height: 12),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePin,
              child: const Text("PIN Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
