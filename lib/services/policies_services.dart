import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/models/policies_models.dart';

class PoliciesServices {
  // Esta es la URL secreta para obtener el permiso de acceso
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');

  Future<PoliciesModels> getPolicies(BuildContext context) async {
    final locale = Localizations.localeOf(context);
    var flag = L10n.getFlag(locale.languageCode);

    var policiesUri =
        Uri.parse('${Constants.baseUrl}/$flag/api/politica_empresa_api/');

    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    var response = await post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(response.body);
    final accessToken = data["access_token"];

    final resp = await get(policiesUri,
        headers: <String, String>{'authorization': "Bearer $accessToken"});

    final utf = const Utf8Decoder().convert(resp.body.codeUnits);
    log(utf);

    return policiesModelsFromJson(utf);
  }
}
