class Plant {
  final int id;
  String imagenPrincipal;
  final String name;
  final String lifestage;
  final String status;
  DateTime fechaRegistro;
  final double latitude;
  final double longitude;

  Plant({
    required this.id,
    required this.imagenPrincipal,
    required this.name,
    required this.lifestage,
    required this.status,
    required this.fechaRegistro,
    required this.latitude,
    required this.longitude,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        id: json['id'],
        imagenPrincipal: json["imagen_principal"],
        name: json['especie_planta'],
        latitude: json["latitude"],
        longitude: json["longitude"],
        lifestage: json['lifestage'],
        status: json['estado_actual'],
        fechaRegistro: DateTime.parse(
          json["fecha_registro_"],
        ));
  }
}
