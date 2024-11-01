// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'betreuer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BetreuerAdapter extends TypeAdapter<Betreuer> {
  @override
  final int typeId = 1;

  @override
  Betreuer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Betreuer(
      vorname: fields[0] as String,
      nachname: fields[1] as String,
      kommentar: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Betreuer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.vorname)
      ..writeByte(1)
      ..write(obj.nachname)
      ..writeByte(2)
      ..write(obj.kommentar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BetreuerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
