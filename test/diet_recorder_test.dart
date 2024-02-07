import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework1/diet_recorder.dart';
import 'package:provider/provider.dart';
import 'package:homework1/points_provider.dart';

void main() {
  testWidgets('Diet Recorder adds food to dropdown list', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RecordedPointsProvider()),
        ],
        child: const MaterialApp(
          home: DietRecorderWidget(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Banana');
    await tester.enterText(find.byType(TextField).at(1), '1');

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Banana'), findsOneWidget);
    expect(
      int.tryParse(find.text('1').evaluate().single.widget.toString()),
      isNull,
    );
  });
}
