// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nom_lifestage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LifestageAdapter extends TypeAdapter<Lifestage> {
  @override
  final typeId = 2;

  @override
  Lifestage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lifestage(
      count: (fields[0] as num).toInt(),
      next: fields[1] as dynamic,
      previous: fields[2] as dynamic,
      results: (fields[3] as List).cast<Result>(),
    );
  }

  @override
  void write(BinaryWriter writer, Lifestage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.count)
      ..writeByte(1)
      ..write(obj.next)
      ..writeByte(2)
      ..write(obj.previous)
      ..writeByte(3)
      ..write(obj.results);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifestageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResultAdapter extends TypeAdapter<Result> {
  @override
  final typeId = 3;

  @override
  Result read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Result(id: (fields[0] as num).toInt(), nombre: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, Result obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
