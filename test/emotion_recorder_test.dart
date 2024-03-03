import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework1/screens/emotion_recorder.dart';
import 'package:homework1/points_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Emotion Recorder adds emoji to list', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => RecordedPointsProvider(),
          child: const EmotionRecorderWidget(),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('emoji_1')));
    await tester.pump();

    expect(find.textContaining('💋'), findsOneWidget);

    expect(find.byType(ListTile), findsWidgets);

  });
}
