import 'package:flutter/material.dart';
import 'package:homework1/points_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'Models/data_model.dart';

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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Diet Recorder',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          _buildInputSection(),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => recordDiet(),
            child: const Text('Submit'),
          ),
          const SizedBox(height: 16.0),
          const Text('Diet Log',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: loggedEntries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    loggedEntries[index]['item'],
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  title: Text(
                    "${loggedEntries[index]['quantity']} times",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          editDiet(index);
                          //print("edit tap!");
                          },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => deleteDiet(index),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildInputSection() {
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
            items: uniqueDietEntries.map<DropdownMenuItem<String>>((String entry) {
              return DropdownMenuItem<String>(
                value: entry,
                child: Text(entry),
              );
            }).toList(),
          ),
        const SizedBox(height: 16.0),
        TextField(
          controller: foodController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'What did you eat?',
          ),
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: quantityController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'How much did you eat?',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  void recordDiet() async {
    Provider.of<RecordedPointsProvider>(context, listen: false).recordPoints('Diet Record');
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
    //print(dietBox.values);
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
        title: const Text('Edit Item and Quantity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              decoration: const InputDecoration(labelText: 'Item'),
            ),
            TextField(
              controller: qntController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancelling the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final String updatedItem = itemController.text;
              final int? updatedQuantity = int.tryParse(qntController.text);
              if (updatedQuantity != null) {
                Navigator.of(context).pop({'item': updatedItem, 'quantity': updatedQuantity});
              }
            },
            child: const Text('Update'),
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
