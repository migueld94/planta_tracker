import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:planta_tracker/models/nom_lifestage.dart';
import 'package:planta_tracker/assets/utils/constants.dart';

class LifestageServices {
  // Esta es la URL secreta para obtener el permiso de acceso
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
  final storage = const FlutterSecureStorage();
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env["API_BASE_DOMAIN"]!,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<Lifestage> getLifestage() async {
    try {
      String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
      String secret =
          'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

      var autorization = await post(
        secretUrl,
        headers: <String, String>{'authorization': basicAuth},
        body: {"grant_type": "client_credentials"},
      );

      final Map<String, dynamic> data = json.decode(autorization.body);
      final accessToken = data["access_token"];

      final response = await dio.get(
        '${dotenv.env["API_BASE_DOMAIN"]}/es/api/lifestage_api/',
        options: Options(
          headers: <String, String>{'authorization': "Bearer $accessToken"},
        ),
      );

      if (response.statusCode == 200) {
        return Lifestage.fromJson(response.data);
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
}
