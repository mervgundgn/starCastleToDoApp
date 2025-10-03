import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    // TODO: burada PinService.savePin(newPin) gibi kaydetme işlemi yapılacak

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN güncellendi ✅")),
      );
      context.pop(); // ✅ Kaydetmeden sonra geri dön
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PIN Değiştir"),
        leading: BackButton( // ✅ Geri butonu
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newPinController,
              decoration: const InputDecoration(labelText: "Yeni PIN"),
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
            TextField(
              controller: _confirmPinController,
              decoration: const InputDecoration(labelText: "Tekrar"),
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
            const SizedBox(height: 16),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _changePin,
              child: const Text("PIN Güncelle"),
            ),
          ],
        ),
      ),
    );
  }
}
