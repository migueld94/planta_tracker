import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Ionicons.arrow_back_outline,
            color: PlantaColors.colorWhite,
          ),
        ),
        backgroundColor: PlantaColors.colorGreen,
        title: AutoSizeText(
          AppLocalizations.of(context)!.details,
          style: context.theme.textTheme.titleApBar,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: GestureDetector(
              onTap: () {
                goToComments(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.clipboard_outline,
                    color: PlantaColors.colorWhite,
                  ),
                  AutoSizeText(
                    'Comentarios',
                    style: TextStyle(
                      color: PlantaColors.colorWhite,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: allPadding24,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 140.0,
                child: ListView.separated(
                  itemCount: 6,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.only(left: 24.0),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => horizontalMargin16,
                  itemBuilder: (context, index) => Container(
                    width: 240.0,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius10,
                      color: PlantaColors.colorWhite,
                      image: const DecorationImage(
                        image: AssetImage(
                          Assets.plant_example,
                        ),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(5, 7),
                          blurRadius: 10,
                          color: PlantaColors.colorBlack.withOpacity(0.3),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              verticalMargin24,
              AutoSizeText(
                '16/04/2024',
                style: context.theme.textTheme.text_01,
              ),
              verticalMargin8,
              AutoSizeText(
                'Excoecaria biglandulosa var. petiolaris Mull. Arg',
                style: context.theme.textTheme.h2.copyWith(fontSize: 23.0),
              ),
              verticalMargin8,
              AutoSizeText(
                'Solanum erianthum',
                style:
                    context.theme.textTheme.subtitle.copyWith(fontSize: 18.0),
              ),
              verticalMargin8,
              Row(
                children: [
                  Container(
                    width: 120,
                    padding: allPadding8,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius20,
                      color: PlantaColors.colorDarkGreen,
                    ),
                    child: Center(
                      child: AutoSizeText(
                        'Aceptado',
                        style: context.theme.textTheme.text_02.copyWith(
                          color: PlantaColors.colorWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  horizontalMargin12,
                  Container(
                    width: 120,
                    padding: allPadding8,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius20,
                      border: Border.all(
                        color: PlantaColors.colorOrange,
                      ),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        'Floreciendo',
                        style: context.theme.textTheme.text_02.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: PlantaColors.colorOrange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              verticalMargin16,
              AutoSizeText(
                'Foto tomada por: Emilio Perez Perez',
                style: context.theme.textTheme.text_01.copyWith(fontSize: 16),
              ),
              verticalMargin8,
              AutoSizeText(
                'Notas',
                style: context.theme.textTheme.h2,
              ),
              verticalMargin8,
              SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: AutoSizeText(
                    'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Accusamus aspernatur odio tenetur, ad natus inventore atque numquam perspiciatis odit ea blanditiis at nostrum labore, dignissimos totam assumenda maxime ab? Corrupti? Lorem ipsum, dolor sit amet consectetur adipisicing elit. Accusamus aspernatur odio tenetur, ad natus inventore atque numquam perspiciatis odit ea blanditiis at nostrum labore, dignissimos totam assumenda maxime ab? Corrupti? Lorem ipsum, dolor sit amet consectetur adipisicing elit. Accusamus aspernatur odio tenetur, ad natus inventore atque numquam perspiciatis odit ea blanditiis at nostrum labore, dignissimos totam assumenda maxime ab? Corrupti? Lorem ipsum, dolor sit amet consectetur adipisicing elit. Accusamus aspernatur odio tenetur, ad natus inventore atque numquam perspiciatis odit ea blanditiis at nostrum labore, dignissimos totam assumenda maxime ab? Corrupti? Lorem ipsum, dolor sit amet consectetur adipisicing elit. Accusamus aspernatur odio tenetur, ad natus inventore atque numquam perspiciatis odit ea blanditiis at nostrum labore, dignissimos totam assumenda maxime ab? Corrupti? Lorem ipsum, dolor sit amet consectetur adipisicing elit. Accusamus aspernatur odio tenetur, ad natus inventore atque numquam perspiciatis odit ea blanditiis at nostrum labore, dignissimos totam assumenda maxime ab? Corrupti? Lorem ipsum, dolor sit amet consectetur adipisicing elit. Accusamus aspernatur odio tenetur, ad natus inventore atque numquam perspiciatis odit ea blanditiis at nostrum labore, dignissimos totam assumenda maxime ab? Corrupti?',
                    style: context.theme.textTheme.text_01,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
