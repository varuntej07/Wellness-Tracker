
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:homework1/points_provider.dart';
import 'package:provider/provider.dart';

import 'Models/data_model.dart';

class WorkoutRecorderWidget extends StatefulWidget {
  const WorkoutRecorderWidget({Key? key}) : super(key: key);

  @override
  State<WorkoutRecorderWidget> createState() => _WorkoutRecorderWidgetState();
}

class _WorkoutRecorderWidgetState extends State<WorkoutRecorderWidget> {
  static const List<String> exercises = <String>[
    'Running', 'Cycling', 'Weightlifting', 'Yoga', 'Swimming', 'Jumping Jacks', 'Boxing', 'Walking'
  ];

  TextEditingController quantityController = TextEditingController();
  List<Map<String, dynamic>> loggedEntries = [];
  String dropdownValue = exercises.first;

  late Box workoutBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    workoutBox = await Hive.openBox('workoutBox');
    final List<Map<String, dynamic>> loadedEntries = [];
    workoutBox.toMap().forEach((key, record) {
      if (record is WorkoutRecord) {
        loadedEntries.add({
          'key': key, // Storing the Hive-generated key for later reference
          'exercise': record.workout,
          'quantity': record.count.toString(),
          //'datetime': DateTime.now().toString(),
        });
      }
    });
    if(mounted) {
      setState(() {
      loggedEntries = loadedEntries;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Workout Recorder',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: exercises.map((exercise) {
                return DropdownMenuItem<String>(
                  key: Key(exercise),
                  value: exercise,
                  child: Text(exercise),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'How many times?',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => recordWorkout(),
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16.0),
            const Text('Workout Log',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: loggedEntries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(loggedEntries[index]['exercise'] ?? '',
                        style: const TextStyle(fontSize: 18.0)
                    ),
                    subtitle: Text('${loggedEntries[index]['quantity']} times',
                        style: const TextStyle(fontSize: 18.0)
                    ),
                    trailing: IconButton(
                      onPressed: () => deleteWorkout(index),
                      icon: const Icon(Icons.delete)
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void recordWorkout() async {
    context.read<RecordedPointsProvider>().recordPoints('Workout Record');
    final String quantityText = quantityController.text;
    final int? quantity = int.tryParse(quantityText);
    if (dropdownValue.isNotEmpty && quantity != null) {
      final String timestamp = DateTime.now().toString();
      final WorkoutRecord entry = WorkoutRecord(dropdownValue, quantity);

      final key = await workoutBox.add(entry);

      // Storing the key with the entry data in the loggedEntries list
      setState(() {
        loggedEntries.add({'key': key, 'exercise': dropdownValue, 'quantity': quantityText, 'datetime': timestamp});
      });

      quantityController.clear();
    }
  }


  void deleteWorkout(int index) async {
    final entry = loggedEntries[index];
    final key = entry['key'] as int;

    // Deleting the entry from the Hive box using the correct key
    await workoutBox.delete(key);

    // Removing the entry from the UI state
    setState(() {
      loggedEntries.removeAt(index);
    });
  }
}
