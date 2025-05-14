import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:planta_tracker/blocs/all_plants/all_plants_bloc.dart';
import 'package:planta_tracker/blocs/all_plants/all_plants_event.dart';
import 'package:planta_tracker/blocs/details_plants/details_plants_bloc.dart';
import 'package:planta_tracker/blocs/details_plants/details_plants_event.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_bloc.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_event.dart';
import 'package:provider/provider.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class LanguagePickerWidget extends StatelessWidget {
  const LanguagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    var flag = L10n.getFlag(locale.languageCode);
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: PlantaColors.colorWhite,
            borderRadius: borderRadius10,
          ),
        ),
        value: flag,
        items:
            L10n.all.map((locale) {
              final flag = L10n.getFlag(locale.languageCode);
              return DropdownMenuItem(
                alignment: Alignment.center,
                value: flag,
                onTap: () {
                  final provider = Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  );
                  provider.setLocale(locale);

                  context.read<AllPlantsBloc>().add(InvalidateCacheAllPlants());
                  context.read<AllPlantsBloc>().add(
                    LoadAllPlants(language: flag),
                  );

                  context.read<MyPlantsBloc>().add(InvalidateCacheMyPlants());
                  context.read<MyPlantsBloc>().add(LoadMyPlants());

                  context.read<PlantDetailBloc>().add(
                    PlantDetailInvalidateCache(),
                  );
                },
                child: AutoSizeText(
                  flag,
                  style: context.theme.textTheme.text_01,
                ),
              );
            }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
