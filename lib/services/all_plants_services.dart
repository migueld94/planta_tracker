import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/models/plants_models.dart';

class AllPlantServices {
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');

  Future<List<Plant>> getAllPlants(
      BuildContext context, int currentPage) async {
    final locale = Localizations.localeOf(context);
    var flag = L10n.getFlag(locale.languageCode);
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    var resp = await http.post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(resp.body);
    final accessToken = data["access_token"];

    final allplant = Uri.parse('${Constants.baseUrl}/$flag/api/plants_map_api');

    final response = await http.get(allplant,
        headers: <String, String>{'authorization': "Bearer $accessToken"});

    // final utf = const Utf8Decoder().convert(response.body.codeUnits);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newMovies = (data['results'] as List)
          .map((json) => Plant.fromJson(json))
          .toList();
      return newMovies;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
