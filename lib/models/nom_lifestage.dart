import 'dart:convert';

import 'package:hive_ce/hive.dart';
part 'nom_lifestage.g.dart';

Lifestage lifestageFromJson(String str) => Lifestage.fromJson(json.decode(str));

String lifestageToJson(Lifestage data) => json.encode(data.toJson());

@HiveType(typeId: 2)
class Lifestage {
  @HiveField(0)
  int count;

  @HiveField(1)
  dynamic next;

  @HiveField(2)
  dynamic previous;

  @HiveField(3)
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
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

@HiveType(typeId: 3)
class Result {
  @HiveField(0)
  int id;

  @HiveField(1)
  String nombre;

  Result({required this.id, required this.nombre});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Result && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Result.fromJson(Map<String, dynamic> json) =>
      Result(id: json["id"], nombre: json["nombre"]);

  Map<String, dynamic> toJson() => {"id": id, "nombre": nombre};
}
