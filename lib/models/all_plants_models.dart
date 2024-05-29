// To parse this JSON data, do
//
//     final allPlants = allPlantsFromJson(jsonString);

import 'dart:convert';

AllPlants allPlantsFromJson(String str) => AllPlants.fromJson(json.decode(str));

String allPlantsToJson(AllPlants data) => json.encode(data.toJson());

class AllPlants {
  int count;
  String next;
  dynamic previous;
  List<Result> results;

  AllPlants({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory AllPlants.fromJson(Map<String, dynamic> json) => AllPlants(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  int id;
  String? especiePlanta;
  double latitude;
  double longitude;
  String imagenPrincipal;
  Lifestage lifestage;
  EstadoActual estadoActual;
  DateTime fechaRegistro;

  Result({
    required this.id,
    required this.especiePlanta,
    required this.latitude,
    required this.longitude,
    required this.imagenPrincipal,
    required this.lifestage,
    required this.estadoActual,
    required this.fechaRegistro,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        especiePlanta: json["especie_planta"],
        latitude: json["latitude"],
        longitude: json["longitude"],
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
            "${fechaRegistro.year.toString().padLeft(4, '0')}-${fechaRegistro.month.toString().padLeft(2, '0')}-${fechaRegistro.day.toString().padLeft(2, '0')}",
      };
}

enum EstadoActual { APROBADO, EN_REVISION, PENDIENTE }

final estadoActualValues = EnumValues({
  "Aprobado": EstadoActual.APROBADO,
  "En Revision": EstadoActual.EN_REVISION,
  "Pendiente": EstadoActual.PENDIENTE
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
