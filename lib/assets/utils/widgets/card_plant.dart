import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/circular_progress.dart';

//* Aqui falta agregarle la foto
class CardPlant extends StatelessWidget {
  const CardPlant({
    super.key,
    required this.title,
    // required this.lifestage,
    required this.status,
    required this.date,
    required this.onTap,
    required this.picture,
  });

  final String title;
  final String picture;
  // final String lifestage;
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
          ],
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                filterQuality: FilterQuality.low,
                imageUrl: picture,
                placeholder: (context, url) => const CircularPlantaTracker(),
                errorWidget:
                    (context, url, error) => Icon(
                      Ionicons.image_sharp,
                      color: PlantaColors.colorBlack,
                    ),
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
                  AutoSizeText(date, style: context.theme.textTheme.text_02),
                  spacer,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius20,
                          color: getColor(),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            status,
                            style: context.theme.textTheme.text_02.copyWith(
                              color: PlantaColors.colorWhite,
                            ),
                          ),
                        ),
                      ),
                      // horizontalMargin8,
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 8.0,
                      //     vertical: 4.0,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     borderRadius: borderRadius20,
                      //     border: Border.all(color: PlantaColors.colorOrange),
                      //   ),
                      //   child: Center(
                      //     child: AutoSizeText(
                      //       lifestage,
                      //       style: context.theme.textTheme.text_02,
                      //     ),
                      //   ),
                      // ),
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
    if ((status.toLowerCase() == 'aprobado') ||
        (status.toLowerCase() == 'approved')) {
      return PlantaColors.colorDarkGreen;
    } else if ((status.toLowerCase() == 'en revision') ||
        (status.toLowerCase() == 'revision')) {
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
    this.status,
    required this.date,
    required this.onTap,
    required this.picture,
    required this.id,
    required this.onTapDelete,
    required this.onTapEdit,
  });

  final String title;
  final String picture;
  final String lifestage;
  final String? status;
  final String date;
  final Function()? onTap;
  final int id;
  final Function()? onTapDelete;
  final Function()? onTapEdit;

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
                      child: CachedNetworkImage(
                        filterQuality: FilterQuality.low,
                        imageUrl: picture,
                        placeholder:
                            (context, url) => const CircularPlantaTracker(),
                        errorWidget:
                            (context, url, error) => Icon(
                              Ionicons.image_sharp,
                              color: PlantaColors.colorBlack,
                            ),
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
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
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius20,
                                    color: getColor(),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      status!,
                                      style: context.theme.textTheme.text_02
                                          .copyWith(
                                            color: PlantaColors.colorWhite,
                                          ),
                                    ),
                                  ),
                                ),
                                horizontalMargin4,
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
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
                  // EDITAR
                  GestureDetector(
                    onTap: onTapEdit,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: getColorOptionEdit()),
                        borderRadius: borderRadius10,
                      ),
                      child: Center(
                        child: Icon(
                          Ionicons.pencil_outline,
                          color:
                              ((status!.toLowerCase() == 'pendiente') ||
                                      (status!.toLowerCase() == 'earring'))
                                  ? PlantaColors.colorBlack
                                  : PlantaColors.colorGrey,
                        ),
                      ),
                    ),
                  ),

                  // ELIMINAR
                  GestureDetector(
                    onTap: onTapDelete,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: getColorOptionDelete()),
                        borderRadius: borderRadius10,
                      ),
                      child: Center(
                        child: Icon(
                          Ionicons.trash_outline,
                          color:
                              ((status!.toLowerCase() == 'pendiente') ||
                                      (status!.toLowerCase() == 'earring'))
                                  ? PlantaColors.colorBlack
                                  : PlantaColors.colorGrey,
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

  Color getColorOptionEdit() {
    if ((status!.toLowerCase() == 'pendiente') ||
        (status!.toLowerCase() == 'earring')) {
      return PlantaColors.colorGreen;
    } else {
      return PlantaColors.colorGrey;
    }
  }

  Color getColorOptionDelete() {
    if ((status!.toLowerCase() == 'pendiente') ||
        (status!.toLowerCase() == 'earring')) {
      return PlantaColors.colorOrange;
    } else {
      return PlantaColors.colorGrey;
    }
  }

  Color getColor() {
    if ((status!.toLowerCase() == 'aprobado') ||
        (status!.toLowerCase() == 'approved')) {
      return PlantaColors.colorDarkGreen;
    } else if ((status!.toLowerCase() == 'en revision') ||
        (status!.toLowerCase() == 'revision')) {
      return PlantaColors.colorLightGreen;
    }
    return PlantaColors.colorDarkOrange;
  }
}

class CardMyPlants2 extends StatelessWidget {
  const CardMyPlants2({
    super.key,
    required this.title,
    // required this.lifestage,
    this.status,
    required this.date,
    required this.onTap,
    required this.onLongPress,
    required this.picture,
    required this.id,
    required this.color,
  });

  final String title;
  final String picture;
  // final String lifestage;
  final String? status;
  final String date;
  final Function()? onTap;
  final Function()? onLongPress;
  final String id;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: borderRadius10,
        color: color,
        boxShadow: [
          BoxShadow(
            color: PlantaColors.colorBlack.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(80)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(80)),
            child: Image.file(File(picture), fit: BoxFit.cover),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              title,
              style: context.theme.textTheme.h3,
              overflow: TextOverflow.ellipsis,
            ),
            AutoSizeText(
              date,
              style: context.theme.textTheme.subtitle,
              overflow: TextOverflow.ellipsis,
            ),
            verticalMargin12,
          ],
        ),
        subtitle: Wrap(
          runSpacing: 8.0,
          spacing: 4.0,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                borderRadius: borderRadius20,
                color: getColor(),
              ),
              child: Row(
                spacing: 4.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    status!.toLowerCase() == 'sin enviar'
                        ? Ionicons.timer_outline
                        : Ionicons.checkmark_done_outline,
                    color: PlantaColors.colorWhite,
                    size: 20.0,
                  ),
                  AutoSizeText(
                    status!,
                    style: context.theme.textTheme.text_02.copyWith(
                      color: PlantaColors.colorWhite,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // IntrinsicWidth(
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 8.0,
            //       vertical: 4.0,
            //     ),
            //     decoration: BoxDecoration(
            //       borderRadius: borderRadius20,
            //       border: Border.all(color: PlantaColors.colorOrange),
            //     ),
            //     child: Text(
            //       lifestage,
            //       style: context.theme.textTheme.text_02.copyWith(
            //         fontSize: 13.0,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  Color getColorOptionEdit() {
    if ((status!.toLowerCase() == 'pendiente') ||
        (status!.toLowerCase() == 'earring')) {
      return PlantaColors.colorGreen;
    } else {
      return PlantaColors.colorGrey;
    }
  }

  Color getColorOptionDelete() {
    if ((status!.toLowerCase() == 'pendiente') ||
        (status!.toLowerCase() == 'earring')) {
      return PlantaColors.colorOrange;
    } else {
      return PlantaColors.colorGrey;
    }
  }

  Color getColor() {
    if (status!.toLowerCase() == 'sin enviar') {
      return PlantaColors.colorYellow;
    } else {
      return PlantaColors.colorDarkGreen;
    }
  }
}
