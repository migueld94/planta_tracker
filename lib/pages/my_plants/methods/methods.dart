import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/services/plants_services.dart';

// Método para enviar la información a la API
Future<http.Response?> sendPlantToApi({
  required BuildContext context,
  required RegisterPlant plant,
}) async {
  final OptionPlantServices optionServices = OptionPlantServices();

  try {
    final response = await optionServices.register(plant: plant);

    if (response == null) {
      throw Exception('La respuesta de la API es nula');
    }

    switch (response.statusCode) {
      case 200:
        final parsedResponse = json.decode(response.body);
        final successValue = parsedResponse['success'];

        if (!context.mounted) return response;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: PlantaColors.colorGreen,
            content: Center(
              child: Text(
                successValue,
                style: context.theme.textTheme.text_01.copyWith(
                  color: PlantaColors.colorWhite,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        );
        return response;
      case 400:
        if (!context.mounted) return response;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: PlantaColors.colorOrange,
            content: Center(
              child: Text(
                response.body,
                style: context.theme.textTheme.text_01.copyWith(
                  color: PlantaColors.colorWhite,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        );
        return response;
      case 401:
      default:
        if (!context.mounted) return response;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: PlantaColors.colorOrange,
            content: Center(
              child: Text(
                response.body,
                style: context.theme.textTheme.text_01.copyWith(
                  color: PlantaColors.colorWhite,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        );
        return response;
    }
  } on SocketException {
    if (!context.mounted) return null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PlantaColors.colorOrange,
        content: Center(
          child: Text(
            AppLocalizations.of(context)!.no_internet,
            style: context.theme.textTheme.text_01.copyWith(
              color: PlantaColors.colorWhite,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  } catch (e) {
    log('Error en sendPlantToApi: $e');
  }

  await Future.delayed(Duration(seconds: 1));
  return null;
}
