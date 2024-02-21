
import 'package:hive/hive.dart';
part 'data_model.g.dart';

//HiveFields for storing recorded Emojis
@HiveType(typeId:0)

class EmotionRecord{

  @HiveField(0)
  final String emoji;

  @HiveField(1)
  final String datetime;

  EmotionRecord(this.datetime, this.emoji);
}

//HiveFields for storing Diet data
@HiveType(typeId: 1)

class DietRecord{
  @HiveField(0)
  final String item;

  @HiveField(1)
  final int quantity;

  DietRecord(this.item, this.quantity);
}

//HiveFields for storing workout data
@HiveType(typeId: 2)

class WorkoutRecord{
  @HiveField(0)
  final String workout;

  @HiveField(1)
  final int count;

  WorkoutRecord(this.workout, this.count);
}

//HiveFields for storing points
@HiveType(typeId: 3)

class RecordedPoints{

  @HiveField(0)
  final String recordingTime;

  @HiveField(1)
  final String recordingType;

  @HiveField(2)
  final int points;

  @HiveField(3)
  final int dedicationLevel;

  RecordedPoints(this.recordingTime, this.recordingType,
      this.points, this.dedicationLevel);
}