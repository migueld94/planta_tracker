import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/circular_progress.dart';
import 'package:planta_tracker/blocs/details_plants/details_plants_bloc.dart';
import 'package:planta_tracker/blocs/details_plants/details_plants_event.dart';
import 'package:planta_tracker/blocs/details_plants/details_plants_state.dart';
import 'package:planta_tracker/models/details_models.dart';
import 'package:planta_tracker/pages/comments/comments.dart';
import 'package:planta_tracker/pages/details_plant/view_image_carrousel.dart';
import 'package:planta_tracker/services/details_services.dart';

class Details extends StatefulWidget {
  final int id;
  const Details({super.key, required this.id});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  DetailsServices detailsServices = DetailsServices();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final lannguage = L10n.getFlag(locale.languageCode);
    context.read<PlantDetailBloc>().add(
      FetchPlantDetail(id: widget.id.toString(), language: lannguage),
    );
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
                Navigator.push(
                  context,
                  SlideRightRoute(page: Comments(id: widget.id)),
                );
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
      body: BlocBuilder<PlantDetailBloc, PlantDetailState>(
        builder: (context, state) {
          if (state is PlantDetailLoading) {
            return const Center(child: CircularPlantaTracker());
          } else if (state is PlantDetailLoaded) {
            final plantDetails = state.plantDetail;
            return DetailsWidget(
              details: plantDetails,
              images: plantDetails.imagenes,
            );
          } else if (state is PlantDetailError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final DetailsModel details;
  final List<Imagene>? images;
  const DetailsWidget({super.key, required this.details, required this.images});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: allPadding16,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 170.0,
              child: ListView.separated(
                itemCount: images!.length,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.only(left: 24.0),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => horizontalMargin16,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideRightRoute(
                          page: ViewImageCarousel(
                            id: images![index].id!,
                            initialPage: index,
                            posterPath: images!,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: images![index].id!,
                      child: Container(
                        width: 240.0,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius10,
                          color: PlantaColors.colorWhite,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(5, 7),
                              blurRadius: 10,
                              color: PlantaColors.colorBlack.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius10,
                          child: CachedNetworkImage(
                            filterQuality: FilterQuality.low,
                            imageUrl:
                                '${Constants.baseUrl}${images?[index].posterPath}',
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularPlantaTracker(),
                                ),
                            errorWidget:
                                (context, url, error) => Icon(
                                  Ionicons.image_sharp,
                                  color: PlantaColors.colorBlack,
                                ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            verticalMargin24,
            AutoSizeText(
              '${details.fechaRegistro?.day} / ${details.fechaRegistro?.month} / ${details.fechaRegistro?.year}',
              style: context.theme.textTheme.text_01,
            ),
            verticalMargin8,
            AutoSizeText(
              details.especiePlanta ?? AppLocalizations.of(context)!.name_plant,
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
                    color: getColor(),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      details.estadoActual ?? '',
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
                      details.lifestage ?? '',
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
              '${AppLocalizations.of(context)!.take_photo_details} ${details.nombreUser}',
              style: context.theme.textTheme.text_01.copyWith(fontSize: 16),
            ),
            verticalMargin8,
            AutoSizeText(
              details.direccionGps ?? AppLocalizations.of(context)!.address,
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
                    initialCenter: LatLng(
                      details.latitude!,
                      details.longitude!,
                    ),
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
                          point: LatLng(details.latitude!, details.longitude!),
                          child: Icon(
                            Ionicons.location_sharp,
                            color: getColor(),
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
              // height: 300,
              child: SingleChildScrollView(
                child: AutoSizeText(
                  details.notas != null && details.notas!.isNotEmpty
                      ? details.notas!
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

  Color getColor() {
    if ((details.estadoActual?.toLowerCase() == 'aprobado') ||
        (details.estadoActual?.toLowerCase() == 'approved')) {
      return PlantaColors.colorDarkGreen;
    } else if ((details.estadoActual?.toLowerCase() == 'en revision') ||
        (details.estadoActual?.toLowerCase() == 'revision')) {
      return PlantaColors.colorLightGreen;
    }
    return PlantaColors.colorDarkOrange;
  }
}
