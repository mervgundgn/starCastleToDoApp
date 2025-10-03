import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:starcastle_todoapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("App smoke test", (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Görevler tabı açıldı mı?
    expect(find.text("Görevler"), findsOneWidget);

    // 🔹 Profil tabına geçiş (icon ya da BottomNavigationBar label olabilir)
    // Eğer BottomNavigationBar kullanıyorsan:
    await tester.tap(find.text("Profil"));
    await tester.pumpAndSettle();

    // Ebeveyn Paneli butonu var mı?
    expect(find.text("Ebeveyn Paneli"), findsOneWidget);
  });
}
