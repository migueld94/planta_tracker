import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/models/plantas_hive.dart';
import 'package:planta_tracker/pages/my_plants/details_my_plant/images_carousel_my_plants.dart';
import 'package:planta_tracker/services/details_services.dart';

class DetailsMyPlants extends StatefulWidget {
  final Planta planta;
  const DetailsMyPlants({super.key, required this.planta});

  @override
  State<DetailsMyPlants> createState() => _DetailsMyPlantsState();
}

class _DetailsMyPlantsState extends State<DetailsMyPlants> {
  DetailsServices detailsServices = DetailsServices();

  @override
  Widget build(BuildContext context) {
    log('Planta ID => ${widget.planta.id}');
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
                // Navigator.push(
                //   context,
                //   SlideRightRoute(page: Comments(id: widget.id)),
                // );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.clipboard_outline,
                    color: PlantaColors.colorWhite,
                  ),
                  AutoSizeText(
                    AppLocalizations.of(context)!.comments,
                    style: TextStyle(color: PlantaColors.colorWhite),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: DetailsWidget(details: widget.planta, images: widget.planta.images),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final Planta details;
  final List<ImagesMyPlant> images;
  const DetailsWidget({super.key, required this.details, required this.images});

  @override
  Widget build(BuildContext context) {
    final List<ImagesMyPlant> filteredImages =
        images.where((image) {
          final fileName = image.posterPath!.split('/').last;
          return !fileName.endsWith("De7au1t.png");
        }).toList();

    return Padding(
      padding: allPadding16,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 240.0,
              child: ListView.builder(
                itemCount: filteredImages.length,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.only(left: 24.0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final image = filteredImages[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        FadeTransitionRoute(
                          page: ViewImageMyPlantsCarousel(
                            id: image.id!,
                            initialPage: index,
                            posterPath: filteredImages,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        spacing: 16.0,
                        children: [
                          Container(
                            width: 260.0,
                            height: 200,
                            padding: allPadding8,
                            decoration: BoxDecoration(
                              borderRadius: borderRadius10,
                              color: PlantaColors.colorWhite,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(5, 7),
                                  blurRadius: 10,
                                  color: PlantaColors.colorBlack.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: borderRadius10,
                              child: Image.file(
                                File(image.posterPath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(image.type),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            verticalMargin24,
            AutoSizeText(
              '${details.fechaCreacion.day} / ${details.fechaCreacion.month} / ${details.fechaCreacion.year}',
              style: context.theme.textTheme.text_01,
            ),
            verticalMargin8,
            AutoSizeText(
              AppLocalizations.of(context)!.name_plant,
              style: context.theme.textTheme.h2.copyWith(fontSize: 23.0),
            ),
            verticalMargin8,
            Row(
              children: [
                Container(
                  width: 120,
                  padding: allPadding8,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius20,
                    color:
                        details.status!.toLowerCase() == 'sin enviar'
                            ? PlantaColors.colorYellow
                            : PlantaColors.colorDarkGreen,
                  ),
                  child: Center(
                    child: AutoSizeText(
                      details.status!,
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
                    border: Border.all(color: PlantaColors.colorOrange),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      details.lifestage,
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
              '${AppLocalizations.of(context)!.take_photo_details} ',
              style: context.theme.textTheme.text_01.copyWith(fontSize: 16),
            ),
            verticalMargin8,
            AutoSizeText(
              'Latitud ${details.latitude} - Longitud ${details.longitude}',
              style: context.theme.textTheme.text_02,
            ),
            verticalMargin8,
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: borderRadius10,
                child: FlutterMap(
                  options: MapOptions(
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                    initialCenter: LatLng(details.latitude, details.longitude),
                    initialZoom: 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(details.latitude, details.longitude),
                          child: Icon(
                            Ionicons.location_sharp,
                            color: PlantaColors.colorRed,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            verticalMargin8,
            AutoSizeText(
              AppLocalizations.of(context)!.note,
              style: context.theme.textTheme.h2,
            ),
            verticalMargin8,
            SizedBox(
              child: SingleChildScrollView(
                child: AutoSizeText(
                  details.nota != null && details.nota!.isNotEmpty
                      ? details.nota!
                      : AppLocalizations.of(context)!.no_notes,
                  style: context.theme.textTheme.text_01,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
