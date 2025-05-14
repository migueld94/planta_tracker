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
      lifestage: fields[4] as String,
      imagenFruto: fields[5] as String?,
      imagenRaiz: fields[6] as String?,
      imagenTallo: fields[7] as String?,
      imagenRamas: fields[8] as String?,
      imagenHoja: fields[9] as String?,
      imagenFlor: fields[10] as String?,
      nota: fields[11] as String?,
      fechaCreacion: fields[12] as DateTime,
      images: (fields[13] as List).cast<ImagesMyPlant>(),
      status: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Planta obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagenPricipal)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.lifestage)
      ..writeByte(5)
      ..write(obj.imagenFruto)
      ..writeByte(6)
      ..write(obj.imagenRaiz)
      ..writeByte(7)
      ..write(obj.imagenTallo)
      ..writeByte(8)
      ..write(obj.imagenRamas)
      ..writeByte(9)
      ..write(obj.imagenHoja)
      ..writeByte(10)
      ..write(obj.imagenFlor)
      ..writeByte(11)
      ..write(obj.nota)
      ..writeByte(12)
      ..write(obj.fechaCreacion)
      ..writeByte(13)
      ..write(obj.images)
      ..writeByte(14)
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
