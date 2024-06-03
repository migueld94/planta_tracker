import 'dart:convert';

CommentModels commentModelsFromJson(String str) =>
    CommentModels.fromJson(json.decode(str));

String commentModelsToJson(CommentModels data) => json.encode(data.toJson());

class CommentModels {
  String? id;
  String? notas;

  CommentModels({
    this.id,
    this.notas,
  });

  factory CommentModels.fromJson(Map<String, dynamic> json) => CommentModels(
        id: json["id"],
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notas": notas,
      };
}
