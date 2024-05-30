import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

      var response = await http.post(userUri,
          headers: <String, String>{'authorization': "Token $token"});

      return userFromJson(response.body);
    } on SocketException {
      throw Exception('Network Conectivity Error');
    } on Exception catch (e) {
      log(e.toString());
      throw Exception('Something Error');
    }
  }

  Future<http.Response> changeName(
      BuildContext context, String fullName) async {
    try {
      final locale = Localizations.localeOf(context);
      var flag = L10n.getFlag(locale.languageCode);
      final token = await storage.read(key: "token");

      var updateNameUri =
          Uri.parse('${Constants.baseUrl}/$flag/api/user_update/');

      var response = await http.put(updateNameUri, headers: <String, String>{
        'authorization': "Token $token"
      }, body: {
        "full_name": fullName,
      });

      return response;
    } on SocketException {
      throw Exception('Network Conectivity Error');
    } on Exception catch (e) {
      log(e.toString());
      throw Exception('Something Error');
    }
  }

  Future<http.Response> changePassword(
      BuildContext context, String password, String passwordConfirm) async {
    try {
      final locale = Localizations.localeOf(context);
      var flag = L10n.getFlag(locale.languageCode);
      final token = await storage.read(key: "token");

      var updatePasswordUri =
          Uri.parse('${Constants.baseUrl}/$flag/api/user_password_update/');

      var response =
          await http.put(updatePasswordUri, headers: <String, String>{
        'authorization': "Token $token"
      }, body: {
        "password": password,
        "password2": passwordConfirm,
      });

      return response;
    } on SocketException {
      throw Exception('Network Conectivity Error');
    } on Exception catch (e) {
      log(e.toString());
      throw Exception('Something Error');
    }
  }
}
