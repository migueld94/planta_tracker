import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/models/comment_models.dart';
import 'package:planta_tracker/models/details_edit_model.dart';
import 'package:planta_tracker/models/my_plants_models.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class OptionPlantServices {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env["API_BASE_DOMAIN"]!,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );
  final storage = const FlutterSecureStorage();
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
  var deleteUri = Uri.parse('${Constants.baseUrl}/en/api/my_plants_delete/');
  var registerPlantUri = Uri.parse('${Constants.baseUrl}/en/api/plants_post/');
  var addComments = Uri.parse('${Constants.baseUrl}/en/api/comentario/');

  Future<MyPlantsModel> getAllMyPlants({required int page}) async {
    final token = await storage.read(key: "token");
    // String idioma = getFlag();
    try {
      Response response = await dio.get(
        '${dotenv.env["API_BASE_DOMAIN"]}my_plants?page=$page',
        options: Options(
          headers: <String, String>{'authorization': "Token $token"},
        ),
      );

      if (response.statusCode == 200) {
        return MyPlantsModel.fromJson(response.data);
      } else {
        throw Exception('Error al cargar los datos');
      }
    } on DioException catch (e) {
      if (e.response == null) {
        log(e.toString());
      }
      throw Exception('Error: ${e.response?.statusMessage}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<void> delete(String id) async {
    var token = await storage.read(key: "token");

    var res = await http.delete(
      deleteUri,
      headers: <String, String>{'authorization': "Token $token"},
      body: {"id": id},
    );

    log(res.body);
  }

  Future<http.Response?> register(RegisterPlant plant) async {
    var token = await storage.read(key: "token");

    final principal = await http.MultipartFile.fromPath(
      'imagen_principal',
      plant.imagenPrincipal!.path,
    );

    final tronco = await http.MultipartFile.fromPath(
      'imagen_tronco',
      plant.imagenTronco!.path,
    );

    final ramas = await http.MultipartFile.fromPath(
      'imagen_ramas',
      plant.imagenRamas!.path,
    );

    final hojas = await http.MultipartFile.fromPath(
      'imagen_hojas',
      plant.imagenHojas!.path,
    );

    final flor = await http.MultipartFile.fromPath(
      'imagen_flor',
      plant.imagenFlor!.path,
    );

    final frutos = await http.MultipartFile.fromPath(
      'imagen_fruto',
      plant.imagenFruto!.path,
    );

    final request = http.MultipartRequest('POST', registerPlantUri);
    request.headers['Authorization'] = 'Token $token';
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

  Future<http.Response?> addComment(CommentModels comments) async {
    var token = await storage.read(key: "token");

    var res = await http.post(
      addComments,
      headers: <String, String>{'authorization': "Token $token"},
      body: comments.toJson(),
    );

    log(res.body);

    return res;
  }

  Future<DetailsEditPlant> getDetailsEdit(BuildContext context, int id) async {
    final locale = Localizations.localeOf(context);
    var flag = L10n.getFlag(locale.languageCode);

    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    var response = await http.post(
      secretUrl,
      headers: <String, String>{'authorization': basicAuth},
      body: {"grant_type": "client_credentials"},
    );

    final Map<String, dynamic> data = json.decode(response.body);
    final accessToken = data["access_token"];

    var detailsEditUri = Uri.parse(
      '${Constants.baseUrl}/$flag/api/detalles_editar_plants_api?id=$id',
    );

    final resp = await http.get(
      detailsEditUri,
      headers: <String, String>{'authorization': "Bearer $accessToken"},
    );

    final utf = const Utf8Decoder().convert(resp.body.codeUnits);

    return detailsEditPlantFromJson(utf);
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(
      byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );
    return file;
  }

  Future<http.Response?> updatePlant(RegisterPlant plant, String id) async {
    var token = await storage.read(key: "token");

    final principal = await http.MultipartFile.fromPath(
      'imagen_principal',
      plant.imagenPrincipal!.path,
    );

    final tronco = await http.MultipartFile.fromPath(
      'imagen_tronco',
      plant.imagenTronco!.path,
    );

    final ramas = await http.MultipartFile.fromPath(
      'imagen_ramas',
      plant.imagenRamas!.path,
    );

    final hojas = await http.MultipartFile.fromPath(
      'imagen_hojas',
      plant.imagenHojas!.path,
    );

    final flor = await http.MultipartFile.fromPath(
      'imagen_flor',
      plant.imagenFlor!.path,
    );

    final frutos = await http.MultipartFile.fromPath(
      'imagen_fruto',
      plant.imagenFruto!.path,
    );

    var updatePlantUri = Uri.parse(
      '${Constants.baseUrl}/en/api/my_plants_update/',
    );

    final request = http.MultipartRequest('PUT', updatePlantUri);
    request.headers['Authorization'] = 'Token $token';
    request.fields['lifestage'] = plant.lifestage!;
    request.fields['notas'] = plant.notas!;
    request.fields['id'] = id;

    request.files.add(principal);
    request.files.add(tronco);
    request.files.add(ramas);
    request.files.add(hojas);
    request.files.add(flor);
    request.files.add(frutos);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    log(response.body);

    if (response.statusCode == 200) {
      log('Este es el response del servicio ${response.body}');
    } else {
      log('Este es el reasonPhrase del servicio ${response.reasonPhrase}');
    }
    return response;
  }
}
