import 'package:flutter/material.dart';
import 'package:homework1/points_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecordedInfoWidget extends StatelessWidget {
  const RecordedInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {

    RecordedPointsProvider appState = Provider.of<RecordedPointsProvider>(context);

    return Consumer<RecordedPointsProvider>(
      builder: (context, recordingProvider, child) {
        return Container(
            //color: Colors.purple[200],
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${AppLocalizations.of(context)!.lastRecordedAt}: ${recordingProvider.lastRecordingTime != null ?
                  DateFormat('yy-MM-dd HH:mm:ss').format(recordingProvider.lastRecordingTime!) : 'No recordings yet'}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${AppLocalizations.of(context)!.lastRecorded}: ${appState.lastRecordingType ?? 'No recordings yet'}",
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text("${AppLocalizations.of(context)!.points}: ${appState.recordingPoints}",
                      style: const TextStyle(
                        fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text("${AppLocalizations.of(context)!.dedicationLevel}: ${appState.dedicationLevel}",
                      style: const TextStyle(
                        fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ],
            )
        );
      },
    );
  }
}