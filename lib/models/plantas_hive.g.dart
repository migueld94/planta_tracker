// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plantas_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantaAdapter extends TypeAdapter<Planta> {
  @override
  final typeId = 0;

  @override
  Planta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Planta(
      id: fields[0] as String,
      imagenPricipal: fields[1] as String,
      latitude: (fields[2] as num).toDouble(),
      longitude: (fields[3] as num).toDouble(),
      imagenFruto: fields[4] as String?,
      imagenRaiz: fields[5] as String?,
      imagenTallo: fields[6] as String?,
      imagenRamas: fields[7] as String?,
      imagenHoja: fields[8] as String?,
      imagenFlor: fields[9] as String?,
      nota: fields[10] as String?,
      fechaCreacion: fields[11] as DateTime,
      images: (fields[12] as List).cast<ImagesMyPlant>(),
      status: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Planta obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagenPricipal)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.imagenFruto)
      ..writeByte(5)
      ..write(obj.imagenRaiz)
      ..writeByte(6)
      ..write(obj.imagenTallo)
      ..writeByte(7)
      ..write(obj.imagenRamas)
      ..writeByte(8)
      ..write(obj.imagenHoja)
      ..writeByte(9)
      ..write(obj.imagenFlor)
      ..writeByte(10)
      ..write(obj.nota)
      ..writeByte(11)
      ..write(obj.fechaCreacion)
      ..writeByte(12)
      ..write(obj.images)
      ..writeByte(13)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImagesMyPlantAdapter extends TypeAdapter<ImagesMyPlant> {
  @override
  final typeId = 1;

  @override
  ImagesMyPlant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImagesMyPlant(
      posterPath: fields[0] as String?,
      id: (fields[1] as num?)?.toInt(),
      type: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ImagesMyPlant obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.posterPath)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImagesMyPlantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
