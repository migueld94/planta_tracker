import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/models/details_models.dart';
import 'package:planta_tracker/pages/comments/comments.dart';
import 'package:planta_tracker/pages/details_plant/view_image.dart';
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
                    SlideRightRoute(
                        page: Comments(
                      id: widget.id,
                    )));
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
      body: FutureBuilder(
        future: detailsServices.getDetails(context, widget.id),
        builder: (context, AsyncSnapshot<DetailsModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            EasyLoading.show();
            return Container();
          } else {
            EasyLoading.dismiss();
            return DetailsWidget(
              details: snapshot.data!,
              images: snapshot.data!.imagenes,
            );
          }
        },
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final DetailsModel details;
  final List<Imagene>? images;
  const DetailsWidget({
    super.key,
    required this.details,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: allPadding24,
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
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              SlideRightRoute(
                                  page: ViewImage(
                                id: images![index].id,
                                type: images![index].type,
                                posterPath:
                                    '${Constants.baseUrl}${images?[index].posterPath}',
                              )));
                        },
                        child: Hero(
                          tag: images![index].id,
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
                                  color:
                                      PlantaColors.colorBlack.withOpacity(0.3),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: borderRadius10,
                              child: CachedNetworkImage(
                                filterQuality: FilterQuality.low,
                                imageUrl:
                                    '${Constants.baseUrl}${images?[index].posterPath}',
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(
                                    Ionicons.image_sharp,
                                    color: PlantaColors.colorBlack),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      verticalMargin8,
                      AutoSizeText(
                        images![index].type,
                        style: context.theme.textTheme.text_01,
                      ),
                    ],
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
            AutoSizeText(
              details.direccionGps ?? AppLocalizations.of(context)!.address,
              style: context.theme.textTheme.text_02,
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
                    border: Border.all(
                      color: PlantaColors.colorOrange,
                    ),
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
              AppLocalizations.of(context)!.note,
              style: context.theme.textTheme.h2,
            ),
            verticalMargin8,
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: AutoSizeText(
                  details.notas ?? AppLocalizations.of(context)!.no_notes,
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
