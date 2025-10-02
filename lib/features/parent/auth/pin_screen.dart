import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_colors.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  late Box settingsBox;
  final TextEditingController _pinController = TextEditingController();
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box("settingsBox");

    // Eğer hiç PIN yoksa default olarak "1234" kaydedelim
    if (!settingsBox.containsKey("parentPIN")) {
      settingsBox.put("parentPIN", "1234");
    }
  }

  void _checkPin() {
    final savedPin = settingsBox.get("parentPIN", defaultValue: "1234");
    if (_pinController.text == savedPin) {
      context.go("/parent/panel");
    } else {
      setState(() {
        errorMessage = "Hatalı PIN, tekrar deneyin!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralGrey,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ebeveyn Girişi",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // PIN input
                TextField(
                  controller: _pinController,
                  obscureText: true,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "4 Haneli PIN",
                  ),
                ),

                if (errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _checkPin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    minimumSize: const Size(150, 48),
                  ),
                  child: const Text(
                    "Giriş Yap",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
