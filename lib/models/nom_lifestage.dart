import 'dart:convert';

Lifestage lifestageFromJson(String str) => Lifestage.fromJson(json.decode(str));

String lifestageToJson(Lifestage data) => json.encode(data.toJson());

class Lifestage {
  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  Lifestage({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory Lifestage.fromJson(Map<String, dynamic> json) => Lifestage(
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
  String nombre;

  Result({
    required this.id,
    required this.nombre,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
