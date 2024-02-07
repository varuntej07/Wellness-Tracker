import 'package:flutter/material.dart';
import 'package:homework1/points_provider.dart';
import 'package:provider/provider.dart';

class DietRecorderWidget extends StatefulWidget {
  const DietRecorderWidget({super.key,});

  @override
  _DietRecorderWidgetState createState() => _DietRecorderWidgetState();
}

class _DietRecorderWidgetState extends State<DietRecorderWidget> {
  TextEditingController foodController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  List<Map<String, dynamic>> loggedEntries = [];
  List<String> uniqueDietEntries = [];
  String? selectedFood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 75),
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Diet Recorder',
              style: TextStyle(fontSize: 28.0),
            ),
            _buildInputSection(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => recordDiet(),
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Diet Log:',
              style: TextStyle(fontSize: 18.0),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: loggedEntries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(loggedEntries[index]['food'] ?? ''),
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

  void recordDiet() {
    String food = selectedFood ?? foodController.text;
    String quantity = quantityController.text;

    if (food.isNotEmpty && quantity.isNotEmpty) {
      String timestamp = DateTime.now().toString();
      Map<String, dynamic> entry = {'food': food, 'quantity': quantity, 'datetime': timestamp};
      setState(() {
        loggedEntries.add(entry);
        if(!uniqueDietEntries.contains(food)){
          uniqueDietEntries.add(food);
        }
        selectedFood = null;
      });
      // Clearing text fields after recording
      foodController.clear();
      quantityController.clear();

      Provider.of<RecordedPointsProvider>(context, listen: false).recordPoints('Diet Record');
    }
  }
}
