import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/models/details_models.dart';

class DetailsServices {
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');

  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env["API_BASE_DOMAIN"]!,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<DetailsModel> fetchBusinessDetail({required String id, required String language}) async {
    try {
      String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
      String secret =
          'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

      var response = await post(
        secretUrl,
        headers: <String, String>{'authorization': basicAuth},
        body: {"grant_type": "client_credentials"},
      );

      final Map<String, dynamic> data = json.decode(response.body);
      final accessToken = data["access_token"];

      var resp = await dio.get(
        '${dotenv.env["API_BASE_DOMAIN"]}$language/api/detalles_plants_api?id=$id',
        options: Options(
          headers: <String, String>{'authorization': "Bearer $accessToken"},
        ),
      );

      if (response.statusCode == 200) {
        return DetailsModel.fromJson(resp.data);
      } else {
        throw Exception('Error al cargar los datos');
      }
    } on DioException catch (e) {
      if (e.response == null) {
        log(e.toString());
        // throw Exception('Error de conexión');
      }
      throw Exception('Error: ${e.response?.statusMessage}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  // Future<DetailsModel> getDetails(BuildContext context, int id) async {
  //   final locale = Localizations.localeOf(context);
  //   var flag = L10n.getFlag(locale.languageCode);

  //   String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
  //   String secret =
  //       'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
  //   String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

  //   var response = await post(secretUrl, headers: <String, String>{
  //     'authorization': basicAuth
  //   }, body: {
  //     "grant_type": "client_credentials",
  //   });

  //   final Map<String, dynamic> data = json.decode(response.body);
  //   final accessToken = data["access_token"];

  //   var detailsUri =
  //       Uri.parse('${Constants.baseUrl}/$flag/api/detalles_plants_api?id=$id');

  //   final resp = await get(detailsUri,
  //       headers: <String, String>{'authorization': "Bearer $accessToken"});

  //   final utf = const Utf8Decoder().convert(resp.body.codeUnits);

  //   return detailsModelFromJson(utf);
  // }
}
