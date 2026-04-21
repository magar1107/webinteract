import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webinteraction/main.dart';

void main() {
  testWidgets('MindUI splash screen renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final tracker = BehaviorTracker.instance;
    await tracker.initialize();

    await tester.pumpWidget(MyApp(tracker: tracker));

    expect(find.text('MindUI'), findsOneWidget);
    expect(find.text('Your interface adapts to you'), findsOneWidget);
  });
}
