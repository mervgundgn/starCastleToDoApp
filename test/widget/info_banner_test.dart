import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:starcastle_todoapp/core/widgets/info_banner.dart';

void main() {
  testWidgets("InfoBanner displays given text", (tester) async {
    const bannerText = "Bilgilendirme mesajı";

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InfoBanner(text: bannerText),
        ),
      ),
    );

    expect(find.text(bannerText), findsOneWidget);
  });
}
