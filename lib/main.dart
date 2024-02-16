import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:homework1/recordedInfo.dart';
import 'package:provider/provider.dart';
import '/workout_recorder.dart';
import '/emotion_recorder.dart';
import '/diet_recorder.dart';
import '/points_provider.dart';
import 'Models/data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EmotionRecordAdapter());
  Hive.registerAdapter(DietRecordAdapter());
  Hive.registerAdapter(WorkoutRecordAdapter());
  Hive.registerAdapter(RecordedPointsAdapter());
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

  Future<void> openHiveBox() async {
    await Hive.openBox<EmotionRecord>('emotionRecords');
  }

  final List<Widget> _widgets = [
    const EmotionRecorderWidget(),
    const DietRecorderWidget(),
    const WorkoutRecorderWidget()
  ];

  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Container(
            color: Colors.white,
            child: const RecordedInfoWidget(),
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: _widgets,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple[400],
        unselectedItemColor: Colors.blueGrey[250],
        showSelectedLabels: true,
        showUnselectedLabels: true,
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
              label: 'Workout'

          )
        ],
        currentIndex: selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}