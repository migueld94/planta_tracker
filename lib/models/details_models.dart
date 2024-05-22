// To parse this JSON data, do
//
//     final detailsModel = detailsModelFromJson(jsonString);

import 'dart:convert';

DetailsModel detailsModelFromJson(String str) => DetailsModel.fromJson(json.decode(str));

String detailsModelToJson(DetailsModel data) => json.encode(data.toJson());

class DetailsModel {
    int? id;
    String? especiePlanta;
    String? latitude;
    String? longitude;
    String? paisGps;
    String? direccionGps;
    String? lifestage;
    String? estadoActual;
    String? nombreUser;
    String? stateGps;
    String? notas;
    List<Imagene>? imagenes;
    DateTime? fechaRegistro;

    DetailsModel({
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
        this.imagenes,
        this.fechaRegistro,
    });

    factory DetailsModel.fromJson(Map<String, dynamic> json) => DetailsModel(
        id: json["id"],
        especiePlanta: json["especie_planta"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        paisGps: json["pais_gps"],
        direccionGps: json["direccion_gps"],
        lifestage: json["lifestage"],
        estadoActual: json["estado_actual"],
        nombreUser: json["nombre_user"],
        stateGps: json["state_gps"],
        notas: json["notas"],
        imagenes: json["imagenes"] == null ? [] : List<Imagene>.from(json["imagenes"]!.map((x) => Imagene.fromJson(x))),
        fechaRegistro: json["fecha_registro_"] == null ? null : DateTime.parse(json["fecha_registro_"]),
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
        "imagenes": imagenes == null ? [] : List<dynamic>.from(imagenes!.map((x) => x.toJson())),
        "fecha_registro_": "${fechaRegistro!.year.toString().padLeft(4, '0')}-${fechaRegistro!.month.toString().padLeft(2, '0')}-${fechaRegistro!.day.toString().padLeft(2, '0')}",
    };
}

class Imagene {
    String? posterPath;

    Imagene({
        this.posterPath,
    });

    factory Imagene.fromJson(Map<String, dynamic> json) => Imagene(
        posterPath: json["poster_path"],
    );

    Map<String, dynamic> toJson() => {
        "poster_path": posterPath,
    };
}
