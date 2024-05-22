import 'dart:convert';

PoliciesModels policiesModelsFromJson(String str) =>
    PoliciesModels.fromJson(json.decode(str));

String policiesModelsToJson(PoliciesModels data) => json.encode(data.toJson());

class PoliciesModels {
  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  PoliciesModels({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PoliciesModels.fromJson(Map<String, dynamic> json) => PoliciesModels(
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
  String descripcion;
  DateTime fechaRegistro;

  Result({
    required this.descripcion,
    required this.fechaRegistro,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        descripcion: json["descripcion"],
        fechaRegistro: DateTime.parse(json["fecha_registro"]),
      );

  Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
        "fecha_registro": fechaRegistro.toIso8601String(),
      };
}
