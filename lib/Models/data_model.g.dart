// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmotionRecordAdapter extends TypeAdapter<EmotionRecord> {
  @override
  final int typeId = 0;

  @override
  EmotionRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmotionRecord(
      fields[1] as String,
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EmotionRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.emoji)
      ..writeByte(1)
      ..write(obj.datetime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DietRecordAdapter extends TypeAdapter<DietRecord> {
  @override
  final int typeId = 1;

  @override
  DietRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietRecord(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DietRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutRecordAdapter extends TypeAdapter<WorkoutRecord> {
  @override
  final int typeId = 2;

  @override
  WorkoutRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutRecord(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.workout)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecordedPointsAdapter extends TypeAdapter<RecordedPoints> {
  @override
  final int typeId = 3;

  @override
  RecordedPoints read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordedPoints(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecordedPoints obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.recordingTime)
      ..writeByte(1)
      ..write(obj.recordingType)
      ..writeByte(2)
      ..write(obj.points)
      ..writeByte(3)
      ..write(obj.dedicationLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordedPointsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
