import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/models/user_models.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserServices {
  final storage = const FlutterSecureStorage();

  Future<User> getUserDetails(BuildContext context) async {
    try {
      final locale = Localizations.localeOf(context);
      var flag = L10n.getFlag(locale.languageCode);
      final token = await storage.read(key: "token");

      var userUri = Uri.parse('${Constants.baseUrl}/$flag/api/user_details/');

      var response = await post(userUri,
          headers: <String, String>{'authorization': "Token $token"});

      return userFromJson(response.body);
    } on SocketException {
      throw Exception('Network Conectivity Error');
    } on Exception catch (e) {
      log(e.toString());
      throw Exception('Something Error');
    }
  }
}
