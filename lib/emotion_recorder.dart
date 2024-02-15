import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:homework1/points_provider.dart';
import 'package:provider/provider.dart';
import 'dataModel.dart';

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
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const Text(
                  'Yo, choose an emoji that suits your current feeling',
                  style: TextStyle(fontSize: 18.0),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 5.0,
                  children: emotions.entries.map((entry) => Material(
                    child: ElevatedButton(
                        key: Key('emoji_${entry.key}'),
                        onPressed: () => recordEmotion(entry.key),
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 20.0),
                        )
                    ),
                  )).toList(),
                ),
                const Text(
                  'Emotion Log:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: loggedEntries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(loggedEntries[index]['emoji']),
                        subtitle: Text(loggedEntries[index]['datetime']),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
        )
    );
  }

  void recordEmotion(int choice) async {
    print('clicked');
    if (emotions.containsKey(choice)) {
      final selectedEmoji = emotions[choice]!;
      final timestamp = DateTime.now().toString();
      final entry = EmotionRecord(timestamp, selectedEmoji);

      setState(() {
        loggedEntries.add({'emoji': entry.emoji, 'datetime': entry.datetime});
        print("Entry added: ${entry.emoji}");
      });
      Provider.of<RecordedPointsProvider>(context, listen: false).recordPoints('Emotion Record');
    }else {
      print("EmojiBox is null or emotion not found for choice: $choice");
    }
  }
}


