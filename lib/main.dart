import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:homework1/recordedInfo.dart';
import 'package:provider/provider.dart';
import '/workout_recorder.dart';
import '/emotion_recorder.dart';
import '/diet_recorder.dart';
import '/points_provider.dart';
import 'dataModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EmotionRecordAdapter());

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
    return const MaterialApp(
      //title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  createState() => _MyHomePage();
}
class _MyHomePage extends State<MyHomePage> {
    int selectedIndex = 0;

    final List<Widget> _widgets = [
        EmotionRecorderWidget(),
        DietRecorderWidget(),
        WorkoutRecorderWidget()
    ];
    void _onTap(int index){
      print("tapped");
      setState(() {
        selectedIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const RecordedInfoWidget(),
        ),
        body: _widgets.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_emotions_outlined),
                label: 'Emotions'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood_rounded),
                label: 'Diet'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.line_weight),
                label: 'workout'
            )
          ],
          currentIndex: selectedIndex,
          onTap: _onTap,
        ),
    );
  }
}