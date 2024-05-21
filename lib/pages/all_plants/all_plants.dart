// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/card_plant.dart';
import 'package:planta_tracker/models/all_plants_models.dart';
import 'package:planta_tracker/pages/details_plant/details.dart';
import 'package:planta_tracker/services/all_plants_services.dart';

class AllPlants extends StatefulWidget {
  const AllPlants({super.key});

  @override
  State<AllPlants> createState() => _AllPlantsState();
}

class _AllPlantsState extends State<AllPlants> {
  final AllPlantServices allPlantServices = AllPlantServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: allPlantServices.getAllPlants(context),
        builder: (context, AsyncSnapshot<AllPlantsModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return AllPlantsWidget(snapshot.data!.results);
          }
        },
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

class AllPlantsWidget extends StatefulWidget {
  final List<Result> plants;
  const AllPlantsWidget(this.plants, {super.key});

  @override
  State<AllPlantsWidget> createState() => _AllPlantsWidgetState();
}

class _AllPlantsWidgetState extends State<AllPlantsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            clipBehavior: Clip.none,
            itemCount: widget.plants.length,
            separatorBuilder: (context, index) => verticalMargin4,
            itemBuilder: (context, index) => CardPlant(
              picture: widget.plants[index].imagenPrincipal,
              title: widget.plants[index].especiePlanta,
              lifestage: widget.plants[index].lifestage,
              status: widget.plants[index].estadoActual,
              date:
                  '${widget.plants[index].fechaRegistro.day.toString()} / ${widget.plants[index].fechaRegistro.month.toString()} / ${widget.plants[index].fechaRegistro.year.toString()}',
              onTap: () {
                Navigator.push(context, SlideRightRoute(page: const Details()));
              },
            ),
          ),
        ),
      ],
    );
  }
}
