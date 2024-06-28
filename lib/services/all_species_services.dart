import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/models/plants_models.dart';

class AllSpeciesServices {
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
  List<Plant> plants = [];

  Future<List<Plant>> getAllPin(
      double latMax, double latMin, double longMax, double longMin) async {
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

    final allPinPlant = Uri.parse('${Constants.baseUrl}/en/api/plants_map_api');

    final request = http.MultipartRequest('GET', allPinPlant);
    request.headers['Authorization'] = 'Bearer $accessToken';

    request.fields.addAll({
      'longitud_maxima': longMax.toString(),
      'longitud_minima': longMin.toString(),
      'latitud_maxima': latMax.toString(),
      'latitud_minima': latMin.toString(),
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final utf = const Utf8Decoder().convert(response.body.codeUnits);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf);
      plants = data.map((json) => Plant.fromJson(json)).toList();
      return plants;
    } else {
      throw Exception('Something Error');
    }
  }

  // Future<List<Plant>> getSpeciesById(int id, double latMax, double latMin,
  //     double longMax, double longMin) async {
  //   String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
  //   String secret =
  //       'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
  //   String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

  //   var resp = await http.post(secretUrl, headers: <String, String>{
  //     'authorization': basicAuth
  //   }, body: {
  //     "grant_type": "client_credentials",
  //   });

  //   final Map<String, dynamic> data = json.decode(resp.body);
  //   final accessToken = data["access_token"];

  //   final speciesById = Uri.parse('${Constants.baseUrl}/en/api/plants_map_api');

  //   final request = http.MultipartRequest('GET', speciesById);
  //   request.headers['Authorization'] = 'Bearer $accessToken';

  //   request.fields.addAll({
  //     'id': id.toString(),
  //     'longitud_maxima': longMax.toString(),
  //     'longitud_minima': longMin.toString(),
  //     'latitud_maxima': latMax.toString(),
  //     'latitud_minima': latMin.toString(),
  //   });

  //   final streamedResponse = await request.send();
  //   final response = await http.Response.fromStream(streamedResponse);

  //   final utf = const Utf8Decoder().convert(response.body.codeUnits);

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(utf);
  //     plants = data.map((json) => Plant.fromJson(json)).toList();
  //     return plants;
  //   } else {
  //     throw Exception('Something Error');
  //   }
  // }

  Future<List<Plant>> getPinsByBoundries(
    LatLng northEast,
    LatLng southWest,
  ) async {
    return [];
  }
}


// class AllPlantServices {
//   var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
//   List<Plant> plants = [];

//   Future<List<Plant>> getAllPin(
//       double latMax, double latMin, double longMax, double longMin) async {
//     String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
//     String secret =
//         'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
//     String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

//     var resp = await http.post(secretUrl, headers: <String, String>{
//       'authorization': basicAuth
//     }, body: {
//       "grant_type": "client_credentials",
//     });

//     final Map<String, dynamic> data = json.decode(resp.body);
//     final accessToken = data["access_token"];

//     final allPinPlant = Uri.parse('${Constants.baseUrl}/en/api/plants_map_api');

//     final response = await http.post(allPinPlant, headers: <String, String>{
//       'authorization': "Bearer $accessToken"
//     }, body: {
//       "longitud_maxima": '$longMax',
//       "longitud_minima": '$longMin',
//       "latitud_maxima": '$latMax',
//       "latitud_minima": '$latMin',
//     });

//     // final utf = const Utf8Decoder().convert(resp.body.codeUnits);

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       plants = data.map((json) => Plant.fromJson(json)).toList();
//       return plants;
//     } else {
//       throw Exception('Something Error');
//     }
//   }

//   Future<List<Plant>> getPinsByBoundries(
//     LatLng northEast,
//     LatLng southWest,
//   ) async {
//     return [];
//   }
// }