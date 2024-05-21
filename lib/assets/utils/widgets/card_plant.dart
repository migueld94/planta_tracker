import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

//* Aqui falta agregarle la foto
class CardPlant extends StatelessWidget {
  const CardPlant({
    super.key,
    required this.title,
    required this.lifestage,
    required this.status,
    required this.date,
    required this.onTap,
    required this.picture,
  });

  final String title;
  final String picture;
  final String lifestage;
  final String status;
  final String date;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90.0,
        padding: allPadding8,
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        decoration: BoxDecoration(
            color: PlantaColors.colorWhite,
            borderRadius: borderRadius10,
            boxShadow: [
              BoxShadow(
                offset: const Offset(5, 7),
                blurRadius: 12,
                color: PlantaColors.colorBlack.withOpacity(0.3),
              ),
            ]),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                filterQuality: FilterQuality.low,
                imageUrl: picture,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Ionicons.image_sharp, color: PlantaColors.colorBlack),
                fit: BoxFit.cover,
                width: 70,
                height: 70,
              ),
            ),
            horizontalMargin16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    title,
                    style: context.theme.textTheme.h3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AutoSizeText(
                    date,
                    style: context.theme.textTheme.text_02,
                  ),
                  spacer,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius20,
                          color: getColor(),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            status,
                            style: context.theme.textTheme.text_02
                                .copyWith(color: PlantaColors.colorWhite),
                          ),
                        ),
                      ),
                      horizontalMargin8,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius20,
                          border: Border.all(color: PlantaColors.colorOrange),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            lifestage,
                            style: context.theme.textTheme.text_02,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor() {
    if (status.toLowerCase() == 'aprobado') {
      return PlantaColors.colorDarkGreen;
    } else if (status.toLowerCase() == 'en_revision') {
      return PlantaColors.colorLightGreen;
    }
    return PlantaColors.colorDarkOrange;
  }
}

class CardMyPlants extends StatelessWidget {
  const CardMyPlants({
    super.key,
    required this.title,
    required this.lifestage,
    required this.status,
    required this.date,
    required this.onTap,
    required this.picture,
  });

  final String title;
  final String picture;
  final String lifestage;
  final String status;
  final String date;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 90.0,
                padding: allPadding8,
                decoration: BoxDecoration(
                  color: PlantaColors.colorWhite,
                  borderRadius: borderRadius10,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(5, 7),
                      blurRadius: 12,
                      color: PlantaColors.colorBlack.withOpacity(0.3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        width: 70,
                        height: 70,
                        picture,
                        fit: BoxFit.cover,
                      ),
                    ),
                    horizontalMargin8,
                    Expanded(
                      child: SizedBox(
                        height: 90.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              title,
                              style: context.theme.textTheme.h3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            verticalMargin2,
                            AutoSizeText(
                              date,
                              style: context.theme.textTheme.subtitle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius20,
                                    color: PlantaColors.colorDarkGreen,
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      status,
                                      style: context.theme.textTheme.text_02
                                          .copyWith(
                                              color: PlantaColors.colorWhite),
                                    ),
                                  ),
                                ),
                                horizontalMargin4,
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius20,
                                    border: Border.all(
                                      color: PlantaColors.colorOrange,
                                    ),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      lifestage,
                                      style: context.theme.textTheme.text_02,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 90.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: PlantaColors.colorGreen),
                        borderRadius: borderRadius10,
                      ),
                      child: Center(
                        child: Icon(
                          Ionicons.pencil_outline,
                          color: PlantaColors.colorBlack,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      warning(context, '¿Esta seguro de eliminar la planta?',
                          () => null);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: PlantaColors.colorOrange),
                        borderRadius: borderRadius10,
                      ),
                      child: Center(
                        child: Icon(
                          Ionicons.trash_outline,
                          color: PlantaColors.colorBlack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
