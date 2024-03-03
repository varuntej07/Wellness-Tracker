import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework1/points_provider.dart';
import 'package:homework1/Models/ui_switch.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import '../Models/data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DietRecorderWidget extends StatefulWidget {
  const DietRecorderWidget({super.key,});

  @override
  State<DietRecorderWidget> createState() => _DietRecorderWidgetState();
}

class _DietRecorderWidgetState extends State<DietRecorderWidget> {
  TextEditingController foodController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  List<Map<String, dynamic>> loggedEntries = [];
  List<String> uniqueDietEntries = [];
  String? selectedFood;

  late Box dietBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    dietBox = await Hive.openBox('dietBox');
    final List<Map<String, dynamic>> loadedEntries = [];

    dietBox.toMap().forEach((key, value) {
      if (value is DietRecord) {
        //print("Loaded Diet: ${value.item}, quantity: ${value.quantity}");
        loadedEntries.add({
          'key': key,
          'item': value.item,
          'quantity': value.quantity,
        });
      }
    });

    if (mounted) {
      setState(() {
        loggedEntries = loadedEntries;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiStyle = Provider.of<UiSwitch>(context).widgetStyle;
      return Scaffold(
          body: Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text( AppLocalizations.of(context)!.dietRecorder,
                style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),

            _buildInputSection(),
            const SizedBox(height: 16.0),

            //Just conditionally changing to required Cupertino Widgets
            uiStyle == WidgetStyle.cupertino ?
            CupertinoButton.filled(
                child: Text(AppLocalizations.of(context)!.submit),
                onPressed:()=> recordDiet()
            )
                : //else
            ElevatedButton(
              onPressed: () => recordDiet(),
              child: Text(AppLocalizations.of(context)!.submit),
            ),
            const SizedBox(height: 16.0),
            Text(AppLocalizations.of(context)!.dietLog,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: loggedEntries.length,
                itemBuilder: (context, index) {
                  //Checking the WidgetStyle and conditionally rendering the widgets
                  if(uiStyle == WidgetStyle.cupertino) {
                    return CupertinoListTile(
                      title: Text(loggedEntries[index]['item'],
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      subtitle: Text("${loggedEntries[index]['quantity']}",
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CupertinoButton(
                            onPressed: () => editDiet(index),
                            child: const Icon(CupertinoIcons.arrow_turn_up_left),
                          ),
                          CupertinoButton(
                            onPressed: () => deleteDiet(index),
                            child: const Icon(CupertinoIcons.delete_solid),
                          ),
                        ],
                      ),
                    );
                  }
                  else {
                    return Card(
                        child: ListTile(
                            title: Text(loggedEntries[index]['item'],
                                style: const TextStyle(fontSize: 18.0)
                            ),
                            subtitle: Text("${loggedEntries[index]['quantity']}",
                                style: const TextStyle(fontSize: 18.0)
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () => editDiet(index),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => deleteDiet(index),
                                  icon: const Icon(Icons.delete)
                                )
                              ]
                            )
                        )
                    );
                  }
                  },
              ),
            ),
            ],
          ),
          )
      );
  }

  void _showPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoPicker(
              backgroundColor: CupertinoColors.systemBackground,
              itemExtent: 36.0,
              onSelectedItemChanged: (int index) {
                setState(() {
                  selectedFood = uniqueDietEntries[index];
                });
              },
              children: List<Widget>.generate(uniqueDietEntries.length, (int index) {
                return Center(
                  child: Text(uniqueDietEntries[index]),
                );
              }),
            ),
          ),
        );
      },
    );
  }

Widget _buildInputSection() {
  final uiStyle = Provider.of<UiSwitch>(context).widgetStyle;
  if (uiStyle == WidgetStyle.material) {
    return Column(
      children: [
        if (uniqueDietEntries.isNotEmpty)
          DropdownButton<String>(
            value: selectedFood,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              setState(() {
                selectedFood = value;
              });
            },
            items: uniqueDietEntries.map<DropdownMenuItem<String>>((
                String entry) {
              return DropdownMenuItem<String>(
                value: entry,
                child: Text(entry),
              );
            }).toList(),
          ),
        const SizedBox(height: 16.0),
        TextField(
          controller: foodController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: AppLocalizations.of(context)!.whatFood,
          ),
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: quantityController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: AppLocalizations.of(context)!.howMuch,
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
  else{
    return Column(
      children: [
        if (uniqueDietEntries.isNotEmpty)
          CupertinoButton(
            onPressed: () => _showPicker(context),
            child: Text(selectedFood ?? AppLocalizations.of(context)!.selectFood),
          ),
        const SizedBox(height: 16.0),
        CupertinoTextFormFieldRow(
          controller: foodController,
          placeholder: AppLocalizations.of(context)!.whatFood,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16.0),
        CupertinoTextFormFieldRow(
          controller: quantityController,
          placeholder: AppLocalizations.of(context)!.howMuch,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

  void recordDiet() async {
    Provider.of<RecordedPointsProvider>(context, listen: false).recordPoints('Diet');
    String food = selectedFood ?? foodController.text;
    int? quantity = int.tryParse(quantityController.text);
    if (food.isNotEmpty && quantity != null) {
      final DietRecord entry = DietRecord(food, quantity);

      // Adding the entry to the Hive box
      final key = await dietBox.add(entry);

      setState(() {
        loggedEntries.add({
          'key': key,
          'item': entry.item,
          'quantity': entry.quantity,
          'datetime': DateTime.now().toString(),
        });
        if (!uniqueDietEntries.contains(food)) {
          uniqueDietEntries.add(food);
        }
        selectedFood = null;
      });

      // Clearing text fields after recording
      foodController.clear();
      quantityController.clear();
    }
  }

  void deleteDiet(int index) async{
    final entry = loggedEntries[index];
    final key = entry['key'];
    await dietBox.delete(key);
    setState((){
      loggedEntries.removeAt(index);
    });
  }

  Future<Map<String, dynamic>?> showEditDialog(BuildContext context, String currentItem, int currentQuantity) async {
    final TextEditingController itemController = TextEditingController(text: currentItem);
    final TextEditingController qntController = TextEditingController(text: currentQuantity.toString());

    return showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.edit),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.item),
            ),
            TextField(
              controller: qntController,
              decoration: InputDecoration(labelText:AppLocalizations.of(context)!.quantity),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancelling the dialog
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              final String updatedItem = itemController.text;
              final int? updatedQuantity = int.tryParse(qntController.text);
              if (updatedQuantity != null) {
                Navigator.of(context).pop({'item': updatedItem, 'quantity': updatedQuantity});
              }
            },
            child: Text(AppLocalizations.of(context)!.update),
          ),
        ],
      ),
    );
  }

  void editDiet(int index) async {
    final String currentItem = loggedEntries[index]['item'];
    final int? currentQuantity = int.tryParse(loggedEntries[index]['quantity'].toString());

    final Map<String, dynamic>? result = await showEditDialog(context, currentItem, currentQuantity ?? 0);
    if (result != null && (result['item'] != currentItem || result['quantity'] != currentQuantity)) {
      final key = loggedEntries[index]['key'];
      final String updatedItem = result['item'];
      final int updatedQuantity = result['quantity'];

      // Updating the Hive box
      final DietRecord updatedRecord = DietRecord(updatedItem, updatedQuantity);
      await dietBox.put(key, updatedRecord);

      // Updating the UI
      setState(() {
        loggedEntries[index]['item'] = updatedItem;
        loggedEntries[index]['quantity'] = updatedQuantity.toString();
      });
    }
  }
}