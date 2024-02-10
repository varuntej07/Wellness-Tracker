import 'package:flutter/material.dart';
import 'package:homework1/points_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Workout Recorder',
              style: TextStyle(fontSize: 28.0),
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
            const Text(
              'Workout Log:',
              style: TextStyle(fontSize: 18.0),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: loggedEntries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(loggedEntries[index]['exercise'] ?? ''),
                    subtitle: Text(loggedEntries[index]['quantity'] ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void recordWorkout() {
    String quantity = quantityController.text;
    if (dropdownValue.isNotEmpty && quantity.isNotEmpty) {
      String timestamp = DateTime.now().toString();
      Map<String, dynamic> entry = {'exercise': dropdownValue, 'quantity': quantity, 'datetime': timestamp};
      setState(() {
        loggedEntries.add(entry);
      });
      // Clearing text field after recording
      quantityController.clear();

      context.read<RecordedPointsProvider>().recordPoints('Workout Record');
    }
  }
}
