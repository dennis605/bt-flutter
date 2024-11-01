// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veranstaltung_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VeranstaltungAdapter extends TypeAdapter<Veranstaltung> {
  @override
  final int typeId = 2;

  @override
  Veranstaltung read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Veranstaltung(
      name: fields[0] as String,
      teilnehmendeBewohner: (fields[1] as List).cast<Bewohner>(),
      betreuer: fields[2] as Betreuer,
      datum: fields[3] as DateTime,
      anfang: fields[4] as DateTime,
      ende: fields[5] as DateTime,
      ort: fields[6] as String,
      beschreibung: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Veranstaltung obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.teilnehmendeBewohner)
      ..writeByte(2)
      ..write(obj.betreuer)
      ..writeByte(3)
      ..write(obj.datum)
      ..writeByte(4)
      ..write(obj.anfang)
      ..writeByte(5)
      ..write(obj.ende)
      ..writeByte(6)
      ..write(obj.ort)
      ..writeByte(7)
      ..write(obj.beschreibung);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VeranstaltungAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
