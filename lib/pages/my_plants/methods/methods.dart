import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/services/plants_services.dart';

// Metodo para enviar la informacion a la api
Future<void> sendPlantToApi({
  required BuildContext context,
  required RegisterPlant plant,
}) async {
  final OptionPlantServices optionServices = OptionPlantServices();

  try {
    final response = await optionServices.register(plant: plant);

    switch (response!.statusCode) {
      case 200:
        final parsedResponse = json.decode(response.body);
        final successValue = parsedResponse['success'];

        if (!context.mounted) return;
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
        break;
      case 400:
        if (!context.mounted) return;
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
        break;
      case 401:
        if (!context.mounted) return;
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
        break;
      default:
        if (!context.mounted) return;
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
        break;
    }
  } on SocketException {
    if (!context.mounted) return;
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
  }
  await Future.delayed(Duration(seconds: 1));
  return;
}
