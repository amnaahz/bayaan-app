import 'package:bayaan/app.dart';
import 'package:bayaan/core/config/app_config.dart';
import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/data/repositories/bayaan_repository.dart';
import 'package:bayaan/features/chat/chat_view.dart';
import 'package:bayaan/features/home/home_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() => const BayaanApp(
  repository: MockBayaanRepository(),
  config: AppConfig(apiBaseUrl: '', useMockData: true),
);

void main() {
  testWidgets('tapping a starter opens the chat transcript', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomeView), findsOneWidget);
    await tester.tap(find.text('What is the GDP of Abu Dhabi?'));
    await tester.pump(); // handle tap
    await tester.pump(const Duration(milliseconds: 200)); // resolve + switch

    expect(find.byType(ChatView), findsOneWidget);

    await tester.pumpWidget(const SizedBox()); // dispose timers
  });

  testWidgets('opening the drawer reveals navigation', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // slide-in

    expect(find.text('New Chat'), findsOneWidget);
    expect(find.text('Spaces'), findsOneWidget);
    expect(find.text('Artifacts'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
