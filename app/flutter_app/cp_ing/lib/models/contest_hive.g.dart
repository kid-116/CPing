// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContestHiveAdapter extends TypeAdapter<ContestHive> {
  @override
  final int typeId = 0;

  @override
  ContestHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContestHive(
      name: fields[0] as String,
      id: fields[1] as String,
      end: fields[2] as String,
      start: fields[3] as String,
      venue: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContestHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.end)
      ..writeByte(3)
      ..write(obj.start)
      ..writeByte(4)
      ..write(obj.venue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContestHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
