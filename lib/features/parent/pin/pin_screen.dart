import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _controller = TextEditingController();
  final String _correctPin = "1234";

  void _checkPin() {
    if (_controller.text == _correctPin) {
      context.go('/parent'); // ✅ ebeveyn paneline yönlendirme
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yanlış PIN")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ebeveyn Girişi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "PIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPin,
              child: const Text("Giriş Yap"),
            )
          ],
        ),
      ),
    );
  }
}
