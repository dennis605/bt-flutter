// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bewohner_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BewohnerAdapter extends TypeAdapter<Bewohner> {
  @override
  final int typeId = 0;

  @override
  Bewohner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bewohner(
      vorname: fields[0] as String,
      nachname: fields[1] as String,
      alter: fields[2] as int,
      kommentar: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Bewohner obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.vorname)
      ..writeByte(1)
      ..write(obj.nachname)
      ..writeByte(2)
      ..write(obj.alter)
      ..writeByte(3)
      ..write(obj.kommentar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BewohnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
