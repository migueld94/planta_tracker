
import 'dart:convert';

AllPlantsModel allPlantsModelFromJson(String str) =>
    AllPlantsModel.fromJson(json.decode(str));

String allPlantsModelToJson(AllPlantsModel data) => json.encode(data.toJson());

class AllPlantsModel {
  int? count;
  dynamic next;
  dynamic previous;
  List<Result>? results;

  AllPlantsModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory AllPlantsModel.fromJson(Map<String, dynamic> json) => AllPlantsModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  int? id;
  String? especiePlanta;
  double? latitude;
  double? longitude;
  String? imagenPrincipal;
  String? lifestage;
  String? estadoActual;
  DateTime? fechaRegistro;

  Result({
    this.id,
    this.especiePlanta,
    this.latitude,
    this.longitude,
    this.imagenPrincipal,
    this.lifestage,
    this.estadoActual,
    this.fechaRegistro,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        especiePlanta: json["especie_planta"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        imagenPrincipal: json["imagen_principal"],
        lifestage: json["lifestage"],
        estadoActual: json["estado_actual"],
        fechaRegistro: json["fecha_registro_"] == null
            ? null
            : DateTime.parse(json["fecha_registro_"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "especie_planta": especiePlanta,
        "latitude": latitude,
        "longitude": longitude,
        "imagen_principal": imagenPrincipal,
        "lifestage": lifestage,
        "estado_actual": estadoActual,
        "fecha_registro_":
            "${fechaRegistro!.year.toString().padLeft(4, '0')}-${fechaRegistro!.month.toString().padLeft(2, '0')}-${fechaRegistro!.day.toString().padLeft(2, '0')}",
      };
}
