// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/card_plant.dart';
import 'package:planta_tracker/pages/details_plant/details.dart';

class MyPlants extends StatelessWidget {
  const MyPlants({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: 15,
              separatorBuilder: (context, index) => verticalMargin4,
              itemBuilder: (context, index) => CardMyPlants(
                picture: Assets.plant_example,
                title: 'Excoecaria biglandulosa var. petiolaris Mull. Arg.',
                lifestage: AppLocalizations.of(context)!.plant_lifestage,
                status: AppLocalizations.of(context)!.plant_status,
                date: AppLocalizations.of(context)!.date,
                onTap: () {
                  Navigator.push(
                      context, SlideRightRoute(page: const Details()));
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: PlantaColors.colorGreen,
        onPressed: () => goToRegisterPlant(context),
        child: Icon(
          Ionicons.add_outline,
          color: PlantaColors.colorWhite,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Ink(
        height: 60.0,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: borderRadius10.topLeft,
            topRight: borderRadius10.topRight,
          ),
          child: BottomAppBar(
            color: PlantaColors.colorGreen,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Ionicons.people_outline,
                    color: PlantaColors.colorWhite,
                  ),
                  onPressed: () => goToProfile(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
