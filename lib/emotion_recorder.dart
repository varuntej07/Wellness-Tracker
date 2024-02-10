import 'package:flutter/material.dart';
import 'package:homework1/points_provider.dart';
import 'package:provider/provider.dart';


class EmotionRecorderWidget extends StatefulWidget {
  const EmotionRecorderWidget({super.key});

  @override
  createState() => _EmotionRecorderWidgetState();
}

class _EmotionRecorderWidgetState extends State<EmotionRecorderWidget> {
  final Map<int, String> emotions = {
    1: "😃", 2: "😊", 3: "😢", 4: "😔", 5: "😎", 6: "😍", 7: "😠", 8: "😴",
    9: '💚', 10: '🤤', 11: '👿', 12:'😖', 13: '😤', 14: '😰', 15: '💔', 16:'🍻',
    17: '🤙', 18: '💋', 19: '🥵', 20:'🍌', 21: '❤️️', 22:'👅', 23:'🙋', 24:'💏'
  };

  List<Map<String, dynamic>> loggedEntries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Emotion Recorder',
                  style: TextStyle(fontSize: 28.0),
                ),
                const Text(
                  'Yo, choose an emoji that suits your current feeling',
                  style: TextStyle(fontSize: 18.0),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: emotions.entries.map((entry) => Material(
                    child: ElevatedButton(
                        key: Key('emoji_${entry.key}'),
                        onPressed: () => recordEmotion(entry.key),
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 24.0),
                        )
                    ),
                  )).toList(),
                ),
                const Text(
                  'Emotion Log:',
                  style: TextStyle(fontSize: 18.0),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: loggedEntries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(loggedEntries[index]['emoji']),
                        subtitle: Text(loggedEntries[index]['datetime']),
                      );
                    },
                  ),
                ),
              ],
            )
        )
    );
  }

  void recordEmotion(int choice) {
    if (emotions.containsKey(choice)) {
      String? selectedEmoji = emotions[choice];
      String timestamp = DateTime.now().toString();
      Map<String, dynamic> entry = {'emoji': selectedEmoji, 'datetime': timestamp};
      setState(() {
        loggedEntries.add(entry);
      });
      Provider.of<RecordedPointsProvider>(context, listen: false).recordPoints('Emotion Record');
    }
  }
}
