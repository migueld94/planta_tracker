// To parse this JSON data, do
//
//     final allPlantsModel = allPlantsModelFromJson(jsonString);

import 'dart:convert';

AllPlantsModel allPlantsModelFromJson(String str) =>
    AllPlantsModel.fromJson(json.decode(str));

String allPlantsModelToJson(AllPlantsModel data) => json.encode(data.toJson());

class AllPlantsModel {
  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  AllPlantsModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory AllPlantsModel.fromJson(Map<String, dynamic> json) => AllPlantsModel(
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
  String especiePlanta;
  String imagenPrincipal;
  String lifestage;
  String estadoActual;
  DateTime fechaRegistro;

  Result({
    required this.id,
    required this.especiePlanta,
    required this.imagenPrincipal,
    required this.lifestage,
    required this.estadoActual,
    required this.fechaRegistro,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        especiePlanta: json["especie_planta"],
        imagenPrincipal: json["imagen_principal"],
        lifestage: json["lifestage"],
        estadoActual: json["estado_actual"],
        fechaRegistro: DateTime.parse(json["fecha_registro_"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "especie_planta": especiePlanta,
        "imagen_principal": imagenPrincipal,
        "lifestage": lifestage,
        "estado_actual": estadoActual,
        "fecha_registro_":
            "${fechaRegistro.year.toString().padLeft(4, '0')}-${fechaRegistro.month.toString().padLeft(2, '0')}-${fechaRegistro.day.toString().padLeft(2, '0')}",
      };
}
