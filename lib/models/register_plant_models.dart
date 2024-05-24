// To parse this JSON data, do
//
//     final registerPlant = registerPlantFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

RegisterPlant registerPlantFromJson(String str) =>
    RegisterPlant.fromJson(json.decode(str));

String registerPlantToJson(RegisterPlant data) => json.encode(data.toJson());

class RegisterPlant {
  String? lifestage;
  String? notas;
  File? imagenPrincipal;
  File? imagenTronco;
  File? imagenRamas;
  File? imagenHojas;
  File? imagenFlor;
  File? imagenFruto;

  RegisterPlant({
    this.lifestage,
    this.notas,
    this.imagenPrincipal,
    this.imagenTronco,
    this.imagenRamas,
    this.imagenHojas,
    this.imagenFlor,
    this.imagenFruto,
  });

  factory RegisterPlant.fromJson(Map<String, dynamic> json) => RegisterPlant(
        lifestage: json["lifestage"],
        notas: json["notas"],
        imagenPrincipal: json["imagen_principal"],
        imagenTronco: json["imagen_tronco"],
        imagenRamas: json["imagen_ramas"],
        imagenHojas: json["imagen_hojas"],
        imagenFlor: json["imagen_flor"],
        imagenFruto: json["imagen_fruto"],
      );

  Map<String, dynamic> toJson() => {
        "lifestage": lifestage,
        "notas": notas,
        "imagen_principal": imagenPrincipal,
        "imagen_tronco": imagenTronco,
        "imagen_ramas": imagenRamas,
        "imagen_hojas": imagenHojas,
        "imagen_flor": imagenFlor,
        "imagen_fruto": imagenFruto,
      };
}
