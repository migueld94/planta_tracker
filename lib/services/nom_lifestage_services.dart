import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/models/nom_lifestage.dart';
import 'package:planta_tracker/assets/utils/constants.dart';

class LifestageServices {
  // Esta es la URL secreta para obtener el permiso de acceso
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');

  Future<Lifestage> getLifestage(BuildContext context) async {
    // Estas dos lineas de codigo son fijas para el tema de la internacionalizacion
    final locale = Localizations.localeOf(context);
    var flag = L10n.getFlag(locale.languageCode);

    // Esta es la URL de la api
    var nomLifestage =
        Uri.parse('${Constants.baseUrl}/$flag/api/lifestage_api/');

    //! Esto es fijo para obtener los datos de las apis oauth2
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    // Aqui obtengo la credencial que me devuelve oauth2
    var response = await post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(response.body);
    final accessToken = data["access_token"];

    // Aqui obtengo los datos de la api despues de la autorizacion
    final resp = await get(nomLifestage,
        headers: <String, String>{'authorization': "Bearer $accessToken"});

    // Aqui codifico para el español
    final utf = const Utf8Decoder().convert(resp.body.codeUnits);

    return lifestageFromJson(utf);
  }
}
