class Plant {
  int? id;
  String? imagenPrincipal;
  String? name;
  String? lifestage;
  String? status;
  DateTime? fechaRegistro;
  double? latitude;
  double? longitude;

  Plant({
    this.id,
    this.imagenPrincipal,
    this.name,
    this.lifestage,
    this.status,
    this.fechaRegistro,
    this.latitude,
    this.longitude,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        id: json['id'],
        imagenPrincipal: json["imagen_principal"],
        name: json['especie_planta'],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        lifestage: json['lifestage'],
        status: json['estado_actual'],
        fechaRegistro: DateTime.parse(
          json["fecha_registro_"],
        ));
  }
}
