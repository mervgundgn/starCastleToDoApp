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

  void _changePin() async {
    final box = await Hive.openBox("settingsBox");
    final currentPin = box.get("parentPIN", defaultValue: "1234"); // ✅ tutarlı key

    if (_oldPinController.text != currentPin) {
      setState(() => _error = "Eski PIN yanlış!");
      return;
    }
    if (_newPinController.text.length != 4) {
      setState(() => _error = "PIN 4 haneli olmalı!");
      return;
    }
    if (_newPinController.text != _confirmPinController.text) {
      setState(() => _error = "Yeni PIN eşleşmiyor!");
      return;
    }

    await box.put("parentPIN", _newPinController.text); // ✅ tutarlı key

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN başarıyla değiştirildi ✅")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PIN Değiştir")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _oldPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Eski PIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Yeni PIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Yeni PIN (tekrar)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _changePin,
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
