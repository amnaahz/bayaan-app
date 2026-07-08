import 'package:bayaan/app.dart';
import 'package:bayaan/core/config/app_config.dart';
import 'package:bayaan/data/repositories/bayaan_repository.dart';
import 'package:bayaan/features/home/home_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots to the home screen with starters', (tester) async {
    await tester.pumpWidget(
      const BayaanApp(
        repository: MockBayaanRepository(),
        config: AppConfig(apiBaseUrl: '', useMockData: true),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(HomeView), findsOneWidget);
    expect(find.text('START A CONVERSATION'), findsOneWidget);
    expect(find.text('What is the GDP of Abu Dhabi?'), findsOneWidget);

    // Tear the tree down so AppState.dispose cancels its periodic timers.
    await tester.pumpWidget(const SizedBox());
  });
}
