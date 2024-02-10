import 'package:flutter/material.dart';

class RecordedPointsProvider extends ChangeNotifier{

  DateTime? _lastRecordingTime;
  String? _lastRecordingType;
  int _recordingPoints = 0;

  DateTime? get lastRecordingTime => _lastRecordingTime;
  String? get lastRecordingType => _lastRecordingType;
  int get recordingPoints => _recordingPoints;

  int get dedicationLevel {
    if (_recordingPoints >= 500) {
      return 5; // Expert
    } else if (_recordingPoints >= 300 && _recordingPoints < 400) {
      return 4; // Dedicated
    } else if (_recordingPoints >= 200 && _recordingPoints < 300) {
      return 3; // Regular
    } else if (_recordingPoints >= 100 && _recordingPoints < 200) {
      return 2; // Novice
    } else {
      return 0; // Beginner
    }
  }
  void recordPoints(String recordingType){
    DateTime currentTime = DateTime.now();

    if (_lastRecordingTime != null) {
      int timeElapsed = currentTime.difference(_lastRecordingTime!).inSeconds;
      //print(hoursElapsed);

      int earnedPoints = (timeElapsed * 5).toInt();
      //print(earnedPoints);

      _recordingPoints += earnedPoints;
      print(_recordingPoints);
    }
    // Updating the last recorded time
    _lastRecordingTime = currentTime;
    _lastRecordingType = recordingType;

    notifyListeners();
  }
}