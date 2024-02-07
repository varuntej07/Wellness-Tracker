import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework1/workout_recorder.dart';
import 'package:provider/provider.dart';
import 'package:homework1/points_provider.dart';

void main() {
  testWidgets('WorkoutRecorderWidget test', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => RecordedPointsProvider(),
          child: WorkoutRecorderWidget(),
        ),
      ),
    );


    expect(find.text('Workout Log:'), findsOneWidget);

    await tester.tap(find.text('Submit'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(0), '10');

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Workout Log:'), findsOneWidget);

    expect(find.text('Running'), findsAtLeastNWidgets(2));
    expect(
      int.tryParse(find.text('10').evaluate().single.widget.toString()),
      isNull,
    );
  });
}
