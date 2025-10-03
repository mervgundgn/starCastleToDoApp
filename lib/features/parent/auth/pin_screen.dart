import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/pin_service.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _controller = TextEditingController();
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    await PinService.initDefaultPin();
    final hasPin = await PinService.hasPin();

    if (!hasPin && mounted) {
      context.go('/parent/set-pin'); // İlk defa giriş → PIN belirleme
    }
  }

  Future<void> _verify() async {
    final entered = _controller.text.trim();
    final ok = await PinService.verifyPin(entered);

    if (ok) {
      if (!mounted) return;
      context.go('/parent/panel');
    } else {
      setState(() => errorMessage = "Hatalı PIN!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PIN Girişi")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "PIN"),
            ),
            const SizedBox(height: 12),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verify,
              child: const Text("Giriş Yap"),
            ),
          ],
        ),
      ),
    );
  }
}
