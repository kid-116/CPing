// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calenderapi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthcalenderAdapter extends TypeAdapter<Authcalender> {
  @override
  final int typeId = 1;

  @override
  Authcalender read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Authcalender()..authHeaders = fields[0] as dynamic;
  }

  @override
  void write(BinaryWriter writer, Authcalender obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.authHeaders);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthcalenderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
