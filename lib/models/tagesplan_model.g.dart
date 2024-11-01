// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tagesplan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TagesplanAdapter extends TypeAdapter<Tagesplan> {
  @override
  final int typeId = 3;

  @override
  Tagesplan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tagesplan(
      datum: fields[0] as DateTime,
      veranstaltungen: (fields[1] as List).cast<Veranstaltung>(),
    );
  }

  @override
  void write(BinaryWriter writer, Tagesplan obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.datum)
      ..writeByte(1)
      ..write(obj.veranstaltungen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagesplanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
