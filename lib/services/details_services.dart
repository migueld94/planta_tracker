import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/models/details_models.dart';

class DetailsServices {
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');

  Future<DetailsModel> getDetails(BuildContext context, int id) async {
    final locale = Localizations.localeOf(context);
    var flag = L10n.getFlag(locale.languageCode);

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

    var detailsUri =
        Uri.parse('${Constants.baseUrl}/$flag/api/detalles_plants_api?id=$id');

    final resp = await get(detailsUri,
        headers: <String, String>{'authorization': "Bearer $accessToken"});

    final utf = const Utf8Decoder().convert(resp.body.codeUnits);

    return detailsModelFromJson(utf);
  }
}
