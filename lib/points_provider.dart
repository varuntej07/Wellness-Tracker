import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:homework1/Models/data_model.dart';


class RecordedPointsProvider extends ChangeNotifier{

  late Box<RecordedPoints> pointsBox;
  RecordedPointsProvider(){
    _initialize();
  }

  Future<void> _initialize() async {
    pointsBox = await Hive.openBox<RecordedPoints>('pointsBox');

    //await pointsBox.clear();
    //used the above clear method to clear all the data from the hive box because there is no
    //logic implemented for decreasing the points recorded whenever the user deletes an entry

    _recordingPoints = 0;

    // Loading and processing the existing records
    for (var record in pointsBox.values) {
      _recordingPoints += record.points;
      _lastRecordingTime = DateTime.parse(record.recordingTime);
      _lastRecordingType = record.recordingType;
    }

    notifyListeners();
  }


  DateTime? _lastRecordingTime;
  String? _lastRecordingType;
  int _recordingPoints = 0;

  DateTime? get lastRecordingTime => _lastRecordingTime;
  String? get lastRecordingType => _lastRecordingType;
  int get recordingPoints => _recordingPoints;

  int get dedicationLevel {
    if(_recordingPoints>500) {
      return 5;  //pro
    } else if (_recordingPoints >=400 && _recordingPoints < 500) {
      return 4; // Expert
    } else if (_recordingPoints >= 300 && _recordingPoints < 400) {
      return 3; // Dedicated
    } else if (_recordingPoints >= 200 && _recordingPoints < 300) {
      return 2; // Regular
    } else if (_recordingPoints >= 100 && _recordingPoints < 200) {
      return 1; // Novice
    } else {
      return 0; // Beginner
    }
  }

  void recordPoints(String recordingType) async {
    final DateTime currentTime = DateTime.now();
    int earnedPoints = 0;

    if (_lastRecordingTime != null) {
      final int timeElapsed = currentTime.difference(_lastRecordingTime!).inSeconds;
      earnedPoints = (timeElapsed * 5).toInt();
      _recordingPoints += earnedPoints;
    }

    // Creating a new RecordedPoints object
    final newRecord = RecordedPoints(
      currentTime.toString(),
      recordingType,
      earnedPoints,
      dedicationLevel,
    );

    // Saving the new record in the Hive box
    await pointsBox.add(newRecord);

    // Updating the provider's state
    _lastRecordingTime = currentTime;
    _lastRecordingType = recordingType;
    notifyListeners();
  }

}