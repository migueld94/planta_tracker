// To parse this JSON data, do
//
//     final detailsEditPlant = detailsEditPlantFromJson(jsonString);

import 'dart:convert';

DetailsEditPlant detailsEditPlantFromJson(String str) =>
    DetailsEditPlant.fromJson(json.decode(str));

String detailsEditPlantToJson(DetailsEditPlant data) =>
    json.encode(data.toJson());

class DetailsEditPlant {
  int? id;
  dynamic especiePlanta;
  double? latitude;
  double? longitude;
  String? paisGps;
  String? direccionGps;
  String? lifestage;
  String? estadoActual;
  String? nombreUser;
  String? stateGps;
  String? notas;
  List<Imageneseditar>? imageneseditar;
  DateTime? fechaRegistro;

  DetailsEditPlant({
    this.id,
    this.especiePlanta,
    this.latitude,
    this.longitude,
    this.paisGps,
    this.direccionGps,
    this.lifestage,
    this.estadoActual,
    this.nombreUser,
    this.stateGps,
    this.notas,
    this.imageneseditar,
    this.fechaRegistro,
  });

  factory DetailsEditPlant.fromJson(Map<String, dynamic> json) =>
      DetailsEditPlant(
        id: json["id"],
        especiePlanta: json["especie_planta"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        paisGps: json["pais_gps"],
        direccionGps: json["direccion_gps"],
        lifestage: json["lifestage"],
        estadoActual: json["estado_actual"],
        nombreUser: json["nombre_user"],
        stateGps: json["state_gps"],
        notas: json["notas"],
        imageneseditar: json["imageneseditar"] == null
            ? []
            : List<Imageneseditar>.from(
                json["imageneseditar"]!.map((x) => Imageneseditar.fromJson(x))),
        fechaRegistro: json["fecha_registro_"] == null
            ? null
            : DateTime.parse(json["fecha_registro_"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "especie_planta": especiePlanta,
        "latitude": latitude,
        "longitude": longitude,
        "pais_gps": paisGps,
        "direccion_gps": direccionGps,
        "lifestage": lifestage,
        "estado_actual": estadoActual,
        "nombre_user": nombreUser,
        "state_gps": stateGps,
        "notas": notas,
        "imageneseditar": imageneseditar == null
            ? []
            : List<dynamic>.from(imageneseditar!.map((x) => x.toJson())),
        "fecha_registro_":
            "${fechaRegistro!.year.toString().padLeft(4, '0')}-${fechaRegistro!.month.toString().padLeft(2, '0')}-${fechaRegistro!.day.toString().padLeft(2, '0')}",
      };
}

class Imageneseditar {
  String? posterPath;
  int? id;
  String? type;

  Imageneseditar({
    this.posterPath,
    this.id,
    this.type,
  });

  factory Imageneseditar.fromJson(Map<String, dynamic> json) => Imageneseditar(
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
