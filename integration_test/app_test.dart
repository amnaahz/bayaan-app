import 'package:bayaan/app.dart';
import 'package:bayaan/core/config/app_config.dart';
import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/data/repositories/bayaan_repository.dart';
import 'package:bayaan/features/chat/chat_view.dart';
import 'package:bayaan/features/home/home_view.dart';
import 'package:bayaan/features/spaces/notebook_overlay.dart';
import 'package:bayaan/features/spaces/spaces_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Widget _app() => const BayaanApp(
  repository: MockBayaanRepository(),
  config: AppConfig(apiBaseUrl: '', useMockData: true),
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('end-to-end: home → chat → spaces → notebook', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(HomeView), findsOneWidget);

    // Ask a starter question → chat opens.
    await tester.tap(find.text('How fast is the population growing?'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(ChatView), findsOneWidget);

    // Start a new chat → back home.
    await tester.tap(find.byIcon(LucideIcons.edit3));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(HomeView), findsOneWidget);

    // Open the drawer and go to Spaces.
    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Spaces'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(SpacesView), findsOneWidget);

    // Open the first notebook.
    await tester.tap(find.text('Economic Anomalies'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(NotebookOverlay), findsOneWidget);

    await tester.pumpWidget(const SizedBox()); // dispose timers
  });
}
