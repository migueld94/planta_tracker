import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlantaColors.colorGreen,
        centerTitle: true,
        iconTheme: IconThemeData(color: PlantaColors.colorWhite),
        title: AutoSizeText(
          AppLocalizations.of(context)!.terms_conditions,
          style: context.theme.textTheme.titleApBar,
        ),
      ),
      body: Padding(
        padding: allPadding16,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_warning,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.h3,
              ),
              verticalMargin16,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_first,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.h3,
              ),
              verticalMargin8,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_first_text,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.text_01,
              ),
              verticalMargin16,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_second,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.h3,
              ),
              verticalMargin8,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_second_text,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.text_01,
              ),
              verticalMargin16,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_three,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.h3,
              ),
              verticalMargin8,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_three_text,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.text_01,
              ),
              verticalMargin16,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_four,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.h3,
              ),
              verticalMargin8,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_four_text,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.text_01,
              ),
              verticalMargin16,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_five,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.h3,
              ),
              verticalMargin8,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_five_text,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.text_01,
              ),
              verticalMargin16,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_six,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.h3,
              ),
              verticalMargin8,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_six_text,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.text_01,
              ),
              verticalMargin16,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_seven,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.text_01,
              ),
              verticalMargin16,
              AutoSizeText(
                AppLocalizations.of(context)!.terms_conditions_eigth,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.h3,
              ),
              verticalMargin16,
              ButtomLarge(
                color: PlantaColors.colorGreen,
                onTap: () {
                  goToRegister(context);
                },
                title: AppLocalizations.of(context)!.text_buttom_accept,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
