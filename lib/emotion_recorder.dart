import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:homework1/points_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Models/data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  late Box emojiBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    emojiBox = await Hive.openBox('emojiBox');
    //print("Box opened: ${emojiBox.isOpen}");
    final List<Map<String, dynamic>> loadedEntries = [];

    emojiBox.toMap().forEach((key, value) {
      if (value is EmotionRecord) {
        loadedEntries.add({
          'key': key,
          'emoji': value.emoji,
          'datetime': value.datetime,
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
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.emotionRecorder,
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.emotionText,
                  style: const TextStyle(fontSize: 18.0),
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
                Text(
                  AppLocalizations.of(context)!.emotionLog,
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: loggedEntries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(loggedEntries[index]['emoji']),
                        subtitle: Text(loggedEntries[index]['datetime']),
                        trailing: IconButton(
                          onPressed: () => deleteEmoji(index),
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
    context.read<RecordedPointsProvider>().recordPoints('Diet Recorder');
    if (emotions.containsKey(choice)) {
      final selectedEmoji = emotions[choice]!;
      final timestamp = DateFormat('yy-MM-dd HH:mm:ss').format(DateTime.now());
      final EmotionRecord entry = EmotionRecord(timestamp, selectedEmoji);

      final key = await emojiBox.add(entry);

      setState(() {
        loggedEntries.add({'key': key, 'emoji': entry.emoji, 'datetime': entry.datetime});
      });
    }
  }

  void deleteEmoji(int index) async {
    final entry = loggedEntries[index];
    final key = entry['key'];

    await emojiBox.delete(key);

    setState(() {
      loggedEntries.removeAt(index); // Removing the entry from the UI state
    });
  }
}


