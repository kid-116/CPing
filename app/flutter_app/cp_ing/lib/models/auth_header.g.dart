// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_header.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthHeaderAdapter extends TypeAdapter<AuthHeader> {
  @override
  final int typeId = 1;

  @override
  AuthHeader read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthHeader(
      header: (fields[0] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AuthHeader obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.header);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthHeaderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
