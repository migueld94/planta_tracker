import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:path_provider/path_provider.dart';

class OptionPlantServices {
  final storage = const FlutterSecureStorage();
  var deleteUri = Uri.parse('${Constants.baseUrl}/en/api/my_plants_delete/');
  var registerPlantUri = Uri.parse('${Constants.baseUrl}/en/api/plants_post/');

  Future<void> delete(String id) async {
    var token = await storage.read(key: "token");

    var res = await http.delete(deleteUri, headers: <String, String>{
      'authorization': "Token $token"
    }, body: {
      "id": id,
    });

    log(res.body);
  }

  Future<http.Response?> register(RegisterPlant plant) async {
    var token = await storage.read(key: "token");

    final principal = await http.MultipartFile.fromPath(
        'imagen_principal', plant.imagenPrincipal!.path);

    final tronco = await http.MultipartFile.fromPath(
        'imagen_tronco', plant.imagenTronco!.path);

    final ramas = await http.MultipartFile.fromPath(
        'imagen_ramas', plant.imagenRamas!.path);

    final hojas = await http.MultipartFile.fromPath(
        'imagen_hojas', plant.imagenHojas!.path);

    final flor = await http.MultipartFile.fromPath(
        'imagen_flor', plant.imagenFlor!.path);

    final frutos = await http.MultipartFile.fromPath(
        'imagen_fruto', plant.imagenFruto!.path);

    log(plant.lifestage!);

    final request = http.MultipartRequest('POST', registerPlantUri);
    request.headers['Authorization'] = 'Token $token';
    // request.fields['lifestage'] = '1';

    request.fields['lifestage'] = plant.lifestage!;
    request.fields['notas'] = plant.notas!;

    request.files.add(principal);
    request.files.add(tronco);
    request.files.add(ramas);
    request.files.add(hojas);
    request.files.add(flor);
    request.files.add(frutos);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      log('Este es el response del servicio ${response.body}');
    } else {
      log('Este es el reasonPhrase del servicio ${response.reasonPhrase}');
    }
    return response;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }
}
