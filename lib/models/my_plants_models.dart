import 'dart:convert';

List<MyPlants> myPlantsFromJson(String str) =>
    List<MyPlants>.from(json.decode(str).map((x) => MyPlants.fromJson(x)));

String myPlantsToJson(List<MyPlants> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyPlants {
  int id;
  String especiePlanta;
  String latitude;
  String longitude;
  String paisGps;
  String direccionGps;
  String stateGps;
  String notas;
  String imagenPrincipal;
  String imagenTronco;
  String imagenRamas;
  String imagenHojas;
  String imagenFlor;
  String imagenFruto;

  MyPlants({
    required this.id,
    required this.especiePlanta,
    required this.latitude,
    required this.longitude,
    required this.paisGps,
    required this.direccionGps,
    required this.stateGps,
    required this.notas,
    required this.imagenPrincipal,
    required this.imagenTronco,
    required this.imagenRamas,
    required this.imagenHojas,
    required this.imagenFlor,
    required this.imagenFruto,
  });

  factory MyPlants.fromJson(Map<String, dynamic> json) => MyPlants(
        id: json["id"],
        especiePlanta: json["especie_planta"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        paisGps: json["pais_gps"],
        direccionGps: json["direccion_gps"],
        stateGps: json["state_gps"],
        notas: json["notas"],
        imagenPrincipal: json["imagen_principal"],
        imagenTronco: json["imagen_tronco"],
        imagenRamas: json["imagen_ramas"],
        imagenHojas: json["imagen_hojas"],
        imagenFlor: json["imagen_flor"],
        imagenFruto: json["imagen_fruto"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "especie_planta": especiePlanta,
        "latitude": latitude,
        "longitude": longitude,
        "pais_gps": paisGps,
        "direccion_gps": direccionGps,
        "state_gps": stateGps,
        "notas": notas,
        "imagen_principal": imagenPrincipal,
        "imagen_tronco": imagenTronco,
        "imagen_ramas": imagenRamas,
        "imagen_hojas": imagenHojas,
        "imagen_flor": imagenFlor,
        "imagen_fruto": imagenFruto,
      };
}
