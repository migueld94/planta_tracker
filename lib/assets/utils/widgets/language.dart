import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
        items: L10n.all.map(
          (locale) {
            final flag = L10n.getFlag(locale.languageCode);
            return DropdownMenuItem(
              alignment: Alignment.center,
              value: flag,
              onTap: () {
                final provider =
                    Provider.of<ThemeProvider>(context, listen: false);
                provider.setLocale(locale);
              },
              child: AutoSizeText(flag),
              // child: flag == 'en'
              //     ? Image.asset(
              //         'icons/flags/png/2.5x/us.png',
              //         package: 'country_icons',
              //         height: 20.0,
              //       )
              //     : Image.asset(
              //         'icons/flags/png/2.5x/es.png',
              //         package: 'country_icons',
              //         height: 20.0,
              //       ),
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
