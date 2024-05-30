// class Plant {
//   int? id;
//   String? imagenPrincipal;
//   String? name;
//   String? lifestage;
//   String? status;
//   DateTime? fechaRegistro;
//   double? latitude;
//   double? longitude;

//   Plant({
//     this.id,
//     this.imagenPrincipal,
//     this.name,
//     this.lifestage,
//     this.status,
//     this.fechaRegistro,
//     this.latitude,
//     this.longitude,
//   });

//   factory Plant.fromJson(Map<String, dynamic> json) {
//     return Plant(
//         id: json['id'],
//         imagenPrincipal: json["imagen_principal"],
//         name: json['especie_planta'],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         lifestage: json['lifestage'],
//         status: json['estado_actual'],
//         fechaRegistro: DateTime.parse(
//           json["fecha_registro_"],
//         ));
//   }
// }
// To parse this JSON data, do
//
//     final plant = plantFromJson(jsonString);

import 'dart:convert';

List<Plant> plantFromJson(String str) =>
    List<Plant>.from(json.decode(str).map((x) => Plant.fromJson(x)));

String plantToJson(List<Plant> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Plant {
  int? id;
  String? especiePlanta;
  double? latitude;
  double? longitude;
  String? imagenPrincipal;
  Lifestage? lifestage;
  EstadoActual? estadoActual;
  DateTime? fechaRegistro;

  Plant({
    this.id,
    this.especiePlanta,
    this.latitude,
    this.longitude,
    this.imagenPrincipal,
    this.lifestage,
    this.estadoActual,
    this.fechaRegistro,
  });

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        id: json["id"],
        especiePlanta: json["especie_planta"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        imagenPrincipal: json["imagen_principal"],
        lifestage: lifestageValues.map[json["lifestage"]]!,
        estadoActual: estadoActualValues.map[json["estado_actual"]]!,
        fechaRegistro: DateTime.parse(json["fecha_registro_"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "especie_planta": especiePlanta,
        "latitude": latitude,
        "longitude": longitude,
        "imagen_principal": imagenPrincipal,
        "lifestage": lifestageValues.reverse[lifestage],
        "estado_actual": estadoActualValues.reverse[estadoActual],
        "fecha_registro_":
            "${fechaRegistro?.year.toString().padLeft(4, '0')}-${fechaRegistro?.month.toString().padLeft(2, '0')}-${fechaRegistro?.day.toString().padLeft(2, '0')}",
      };
}

enum EstadoActual { APPROVED, EARRING, REVISION }

final estadoActualValues = EnumValues({
  "Approved": EstadoActual.APPROVED,
  "Earring": EstadoActual.EARRING,
  "Revision": EstadoActual.REVISION
});

enum Lifestage { BLOOMING, FRUITING, YOUTH }

final lifestageValues = EnumValues({
  "Blooming": Lifestage.BLOOMING,
  "Fruiting": Lifestage.FRUITING,
  "Youth": Lifestage.YOUTH
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
