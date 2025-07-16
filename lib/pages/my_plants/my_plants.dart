import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_bloc.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_event.dart';
import 'package:planta_tracker/pages/my_plants/planta_enviada/planta_enviada_screen.dart';
import 'package:planta_tracker/pages/my_plants/planta_pendiente/planta_pendiente_screen.dart';

class MyPlants extends StatefulWidget {
  final Function(bool) onLoadingChanged;
  const MyPlants({super.key, required this.onLoadingChanged});

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants> {
  bool isSend = false;
  bool isPendient = true;
  bool isLoading = false;

  void _handleLoadingChange(bool loading) {
    log(loading.toString());
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    var language = L10n.getFlag(locale.languageCode);
    context.read<MyPlantsBloc>().add(LoadMyPlants(language: language));

    log(isLoading.toString());
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              selected: isSend,
              label: Text(AppLocalizations.of(context)!.sending),
              elevation: 1.0,
              selectedColor: Colors.green.withOpacity(0.3),
              onSelected:
                  isLoading
                      ? null
                      : (value) {
                        setState(() {
                          isSend = true;
                          isPendient = false;
                        });
                      },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              selected: isPendient,
              label: Text(AppLocalizations.of(context)!.non_sending),
              elevation: 1.0,
              selectedColor: Colors.green.withOpacity(0.3),
              onSelected: (value) {
                setState(() {
                  isSend = false;
                  isPendient = true;
                });
              },
            ),
          ],
        ),
        Expanded(
          child:
              isPendient
                  ? PlantasPendientesScreen(
                    onLoadingChanged: _handleLoadingChange,
                  )
                  : const PlantsSentView(),
        ),
      ],
    );
  }
}
