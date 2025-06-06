import 'dart:convert';

import 'package:hive_ce/hive.dart';

part 'plantas_hive.g.dart';

List<Planta> plantaFromJson(String str) =>
    List<Planta>.from(json.decode(str).map((x) => Planta.fromJson(x)));

String plantaToJson(List<Planta> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 0)
class Planta {
  @HiveField(0)
  String id;

  @HiveField(1)
  String imagenPricipal;

  @HiveField(2)
  double latitude;

  @HiveField(3)
  double longitude;

  // @HiveField(4)
  // String lifestage;

  @HiveField(4)
  String? imagenFruto;

  @HiveField(5)
  String? imagenRaiz;

  @HiveField(6)
  String? imagenTallo;

  @HiveField(7)
  String? imagenRamas;

  @HiveField(8)
  String? imagenHoja;

  @HiveField(9)
  String? imagenFlor;

  @HiveField(10)
  String? nota;

  @HiveField(11)
  DateTime fechaCreacion;

  @HiveField(12)
  List<ImagesMyPlant> images;

  @HiveField(13)
  String? status;

  Planta({
    required this.id,
    required this.imagenPricipal,
    required this.latitude,
    required this.longitude,
    // required this.lifestage,
    this.imagenFruto,
    this.imagenRaiz,
    this.imagenTallo,
    this.imagenRamas,
    this.imagenHoja,
    this.imagenFlor,
    this.nota,
    required this.fechaCreacion,
    required this.images,
    this.status,
  });

  factory Planta.fromJson(Map<String, dynamic> json) => Planta(
    id: json["id"],
    imagenPricipal: json["imagen_pricipal"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    // lifestage: json["lifestage"],
    imagenFruto: json["imagen_fruto"],
    imagenRaiz: json["imagen_raiz"],
    imagenTallo: json["imagen_tallo"],
    imagenRamas: json["imagen_ramas"],
    imagenHoja: json["imagen_hoja"],
    imagenFlor: json["imagen_flor"],
    nota: json["nota"],
    fechaCreacion: DateTime.parse(json["fecha_creacion"]),
    images: List<ImagesMyPlant>.from(
      json["imagenes"]!.map((x) => ImagesMyPlant.fromJson(x)),
    ),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imagen_pricipal": imagenPricipal,
    "latitude": latitude,
    "longitude": longitude,
    // "lifestage": lifestage,
    "imagen_fruto": imagenFruto,
    "imagen_raiz": imagenRaiz,
    "imagen_tallo": imagenTallo,
    "imagen_ramas": imagenRamas,
    "imagen_hoja": imagenHoja,
    "imagen_flor": imagenFlor,
    "nota": nota,
    "fecha_creacion": fechaCreacion.toIso8601String(),
    "imagenes": List<dynamic>.from(images.map((x) => x.toJson())),
    "status": status,
  };
}

@HiveType(typeId: 1)
class ImagesMyPlant {
  @HiveField(0)
  String? posterPath;

  @HiveField(1)
  int? id;

  @HiveField(2)
  String type;

  ImagesMyPlant({this.posterPath, this.id, required this.type});

  factory ImagesMyPlant.fromJson(Map<String, dynamic> json) => ImagesMyPlant(
    posterPath: json["poster_path"],
    id: json["id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "poster_path": posterPath,
    "id": id,
    "type": type,
  };
}
