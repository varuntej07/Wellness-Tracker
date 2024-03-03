import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../Models/data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:homework1/Models/ui_switch.dart';
import 'package:homework1/points_provider.dart';

class WorkoutRecorderWidget extends StatefulWidget {
  const WorkoutRecorderWidget({Key? key}) : super(key: key);

  @override
  createState() => _WorkoutRecorderWidgetState();
}

class _WorkoutRecorderWidgetState extends State<WorkoutRecorderWidget> {
  late List<String> exercises;

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
    loadEntries();
  }

  void loadEntries() {
    final List<Map<String, dynamic>> loadedEntries = [];
    workoutBox.toMap().forEach((key, record) {
      if (record is WorkoutRecord) {
        loadedEntries.add({
          'key': key,
          'exercise': record.workout,
          'quantity': record.count.toString(),
        });
      }
    });

    setState(() {
      loggedEntries = loadedEntries;
    });
  }

  @override
  Widget build(BuildContext context) {
    exercises = [
      AppLocalizations.of(context)!.running,
      AppLocalizations.of(context)!.walking,
      AppLocalizations.of(context)!.gym,
      AppLocalizations.of(context)!.yoga,
      AppLocalizations.of(context)!.swimming,
      AppLocalizations.of(context)!.boxing,
      AppLocalizations.of(context)!.tennis,
      AppLocalizations.of(context)!.cycling
    ];
    final uiStyle = Provider.of<UiSwitch>(context).widgetStyle;
    return uiStyle == WidgetStyle.cupertino ? buildCupertinoUI() : buildMaterialUI();
  }

  Widget buildCupertinoUI() {
    return CupertinoPageScaffold(
      child: SafeArea(child: buildBody(isCupertino: true)),
    );
  }

  Widget buildMaterialUI() {
    return Scaffold(
      body: buildBody(isCupertino: false),
    );
  }

  Widget buildBody({required bool isCupertino}) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize : MainAxisSize.max,
        children: [
          Text(AppLocalizations.of(context)!.workoutRecorder,
            style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          isCupertino ? CupertinoButton(
            onPressed: () => _showPicker(context),
            child: Text(AppLocalizations.of(context)!.choose))
              :
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: exercises.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 16.0),
          isCupertino ? CupertinoTextFormFieldRow(
            controller: quantityController,
            keyboardType: TextInputType.number,
            placeholder: AppLocalizations.of(context)!.howMany)
              :
          TextField(
            controller: quantityController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.howMany,
              border: isCupertino ? null : const OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16.0),

          isCupertino ? CupertinoButton.filled(
            onPressed: recordWorkout,
            child: Text(AppLocalizations.of(context)!.submit))
              :
          ElevatedButton(
            onPressed: recordWorkout,
            child: Text(AppLocalizations.of(context)!.submit)),

          Expanded(child: buildLoggedEntriesList()),
        ],
      ),
        )
    );
  }

  Widget buildLoggedEntriesList() {
    return Card(
        child: ListView.builder(
          itemCount: loggedEntries.length,
          itemBuilder: (context, index) {
            final entry = loggedEntries[index];
            return ListTile(
              title: Text(entry['exercise'] ?? ''),
              subtitle: Text('${entry['quantity']} times'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteWorkout(index),
              ),
            );
          },
        )
    );
  }

  void _onPick(int index) {
    setState(() {
      dropdownValue = exercises[index];
    });
  }

  _showPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 180,
        color: Theme.of(context).cardColor,
        child: CupertinoPicker(
          itemExtent: 60,
          onSelectedItemChanged: _onPick,
          children: exercises.map((option) => Text(option)).toList(),
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