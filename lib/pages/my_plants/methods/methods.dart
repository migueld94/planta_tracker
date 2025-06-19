// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/models/plantas_hive.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/services/plants_services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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

Future<bool> hasInternetConnection() async {
  return await InternetConnectionChecker.createInstance().hasConnection;
}

void mostrarSnackBarSeguro(
  BuildContext context,
  String mensaje, {
  bool error = false,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger != null) {
    messenger.showSnackBar(
      SnackBar(
        backgroundColor:
            error ? PlantaColors.colorRed : PlantaColors.colorGreen,
        content: Center(
          child: Text(
            mensaje,
            style: context.theme.textTheme.text_01.copyWith(
              color: PlantaColors.colorWhite,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  } else {
    log("SnackBar no pudo mostrarse: $mensaje");
  }
}

// Metodo para registrar las plantas automaticamente al levantar la aplicacion
Future<void> sincronizarPlantas({required BuildContext context}) async {
  final box = await Hive.openBox<Planta>('plantasBox');
  final plantasNoEnviadas =
      box.values
          .where((planta) => planta.status?.toLowerCase() == 'sin enviar')
          .toList();

  if (plantasNoEnviadas.isEmpty) return;

  final tieneInternet = await hasInternetConnection();
  if (!tieneInternet && context.mounted) {
    mostrarSnackBarSeguro(
      context,
      AppLocalizations.of(context)!.no_internet,
      error: true,
    );
    return;
  }

  List<Future> updateFutures = [];

  for (var planta in plantasNoEnviadas) {
    try {
      RegisterPlant plantRegister = RegisterPlant(
        imagenPrincipal: File(planta.imagenPricipal),
        imagenFlor: File(planta.imagenFlor!),
        imagenFruto: File(planta.imagenFruto!),
        imagenHojas: File(planta.imagenHoja!),
        imagenRamas: File(planta.imagenRamas!),
        imagenTronco: File(planta.imagenTallo!),
        notas: planta.nota,
        latitude: planta.latitude,
        longitude: planta.longitude,
      );

      var response = await sendPlantToApi(
        context: context,
        plant: plantRegister,
      );

      if (response != null && response.statusCode == 200) {
        final key = box.keyAt(box.values.toList().indexOf(planta));
        updateFutures.add(box.delete(key));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: PlantaColors.colorGreen,
            content: Center(
              child: AutoSizeText(
                'Planta registrada con éxito',
                style: context.theme.textTheme.text_01.copyWith(
                  color: PlantaColors.colorWhite,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        );
        log(
          'Enviado correctamente => ID: ${planta.id}, status: ${planta.status}',
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: PlantaColors.colorRed,
            content: Center(
              child: AutoSizeText(
                'Error al enviar la planta',
                style: context.theme.textTheme.text_01.copyWith(
                  color: PlantaColors.colorWhite,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        );
        log(
          'Error al enviar la planta => ID: ${planta.id}, status: ${response?.statusCode ?? 'null'}',
        );
      }
    } catch (e) {
      log("Error al procesar la planta: $e");
    }
  }

  // Esperar las eliminaciones al final
  await Future.wait(updateFutures);
}
