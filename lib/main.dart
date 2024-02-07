import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/workout_recorder.dart';
import '/emotion_recorder.dart';
import '/diet_recorder.dart';
import '/points_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RecordedPointsProvider(),
      child: const MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Assignment-1 with mock data'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    final List<Widget> pages = [
      const Center(child: EmotionRecorderWidget()),
      const Center(child: DietRecorderWidget()),
      const Center(child: WorkoutRecorderWidget()),
    ];

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: pages
                  .map((page) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: page,
                ),
              ).toList(),
            ),
          ),
          const Positioned(
            top: 30.0,
            left: 30.0,
            child: RecordedInfoWidget(),
          ),
        ],
      ),
    );
  }
}

class RecordedInfoWidget extends StatelessWidget {
  const RecordedInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    RecordedPointsProvider appState = Provider.of<RecordedPointsProvider>(context);
    return Consumer<RecordedPointsProvider>(
      builder: (context, recordingProvider, child) {
        return Container(
          color: CupertinoColors.systemGrey4,
            child: Column(
            children:[
            Text("Last Recorded at: ${appState.lastRecordingTime ?? 'No recordings yet'}",
              style: const TextStyle(
                fontSize: 16.0,
                  fontStyle: FontStyle.italic
              ),
            ),
            Text("Last Recorded: ${appState.lastRecordingType ?? 'No recordings yet'}",
              style: const TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            Row(
              children: [
                Text("Points earned: ${appState.recordingPoints}",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 10),
                Text("Dedication Level: ${appState.dedicationLevel}",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
          )
        );
      },
    );
  }
}

