import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:homework1/points_provider.dart';
import 'package:provider/provider.dart';
import 'Models/data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:homework1/ui_switch.dart';

class WorkoutRecorderWidget extends StatefulWidget {
  const WorkoutRecorderWidget({Key? key}) : super(key: key);

  @override
  State<WorkoutRecorderWidget> createState() => _WorkoutRecorderWidgetState();
}

class _WorkoutRecorderWidgetState extends State<WorkoutRecorderWidget> {
  List<String> exercises = [
    'Running', 'Walking', 'Swimming','Yoga','Gym','Tennis', 'Boxing', 'Jumping jacks'
  ];

  TextEditingController quantityController = TextEditingController();
  List<Map<String, dynamic>> loggedEntries = [];
  String? dropdownValue;

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

  void _onPick(int index) {
   // _onDropdownEntrySelected(exercises[index]);
    setState(() {
      dropdownValue = exercises[index];
    });
  }

  _showPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 150,
        color: Theme.of(context).cardColor,
        child: CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged: _onPick,
          children: exercises.map((option) => Text(option)).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiStyle = Provider.of<UiSwitch>(context).widgetStyle;
    if(uiStyle == WidgetStyle.cupertino){
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(AppLocalizations.of(context)!.workoutRecorder,
            style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              CupertinoButton(
                onPressed: () => _showPicker(context),
                child: const Text('Choose a workout')
              ),
              const SizedBox(height: 16.0),
              CupertinoTextFormFieldRow(
                controller: quantityController,
                keyboardType: TextInputType.number,
                placeholder: AppLocalizations.of(context)!.howMany,
              ),
              const SizedBox(height: 16.0),
              CupertinoButton.filled(
                onPressed: () => recordWorkout(),
                child: Text(AppLocalizations.of(context)!.submit),
              ),
              const SizedBox(height: 16.0),
              Center(
                child:Text(AppLocalizations.of(context)!.workoutLog,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: loggedEntries.length,
                  itemBuilder: (context, index) {
                    return CupertinoListTile(
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
        )
      );
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.workoutRecorder,
              style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: dropdownValue ?? (exercises.isNotEmpty ? exercises.first : null),
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (value) {
                if(value!= null) {
                  setState(() {
                    dropdownValue = value;
                  });
                }
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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.howMany,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => recordWorkout(),
              child: Text(AppLocalizations.of(context)!.submit),
            ),
            const SizedBox(height: 16.0),
            Text(AppLocalizations.of(context)!.workoutLog,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
    context.read<RecordedPointsProvider>().recordPoints('Workout');
    final String quantityText = quantityController.text;
    final int? quantity = int.tryParse(quantityText);
    if (dropdownValue!.isNotEmpty && quantity != null) {
      final String timestamp = DateTime.now().toString();
      final WorkoutRecord entry = WorkoutRecord(dropdownValue!, quantity);

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