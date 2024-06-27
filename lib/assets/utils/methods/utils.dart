// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/pages/login/forgot_password.dart';
import 'package:planta_tracker/pages/login/login.dart';
import 'package:planta_tracker/pages/login/register.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/pages/login/terms.dart';
import 'package:planta_tracker/pages/profile_user/profile_user.dart';
import 'package:planta_tracker/pages/register_plants/register_plant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<Object?> warning(BuildContext context, String text, Function() onTap) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    animationType: DialogTransitionType.slideFromTop,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
    builder: (BuildContext context) => Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Container(
        height: 200.0,
        padding: allPadding16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Ionicons.close_outline,
                    color: PlantaColors.colorBlack,
                  ),
                ],
              ),
            ),
            AutoSizeText(
              text,
              style: context.theme.textTheme.text_01,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtomSmall(
                  color: PlantaColors.colorOrange,
                  onTap: () => Navigator.pop(context),
                  title: AppLocalizations.of(context)!.text_buttom_denied,
                ),
                horizontalMargin16,
                ButtomSmall(
                  onTap: onTap,
                  color: PlantaColors.colorGreen,
                  title: AppLocalizations.of(context)!.text_buttom_accept,
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Future<Object?> alert(BuildContext context, String text) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    animationType: DialogTransitionType.slideFromTop,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
    builder: (BuildContext context) => Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 200,
        padding: allPadding16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Ionicons.close_outline,
                    color: PlantaColors.colorBlack,
                  ),
                ],
              ),
            ),
            AutoSizeText(
              text,
              style: context.theme.textTheme.text_01,
              textAlign: TextAlign.center,
            ),
            emptyWidget,
          ],
        ),
      ),
    ),
  );
}

Future<Object?> tutorial(BuildContext context) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    animationType: DialogTransitionType.slideFromTop,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
    builder: (BuildContext context) => Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 220,
        padding: allPadding16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Ionicons.close_outline,
                    color: PlantaColors.colorBlack,
                  ),
                ],
              ),
            ),
            AutoSizeText(
              AppLocalizations.of(context)!.message_plants_empty,
              style: context.theme.textTheme.text_01,
              textAlign: TextAlign.center,
            ),
            Icon(
              Ionicons.arrow_down_outline,
              color: PlantaColors.colorBlack,
            ),
            CircleAvatar(
              backgroundColor: PlantaColors.colorGreen,
              child: Icon(
                Ionicons.add_outline,
                color: PlantaColors.colorWhite,
              ),
            ),
            // AutoSizeText(
            //   text,
            //   style: context.theme.textTheme.text_01,
            //   textAlign: TextAlign.center,
            // ),
            emptyWidget,
          ],
        ),
      ),
    ),
  );
}

Future<Object?> info(BuildContext context, String lifestage, String status,
    String name, Color color, Function()? onTap) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    animationType: DialogTransitionType.slideFromTop,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
    builder: (BuildContext context) => Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius10,
        child: Container(
          width: 250,
          height: 150,
          padding: allMargin16,
          color: PlantaColors.colorWhite.withOpacity(0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                name,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.text_02.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius20,
                      color: color,
                    ),
                    child: Center(
                      child: AutoSizeText(
                        status,
                        style: context.theme.textTheme.text_02.copyWith(
                          color: PlantaColors.colorWhite,
                          fontSize: 14.0,
                        ),
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
                        style: context.theme.textTheme.text_02.copyWith(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius10,
                    color: PlantaColors.colorGreen,
                  ),
                  child: Center(
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.details,
                      style: context.theme.textTheme.textButtomLarge
                          .copyWith(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<File> urlToFile(String imageUrl) async {
  final filename = imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename');
  await http.get(Uri.parse(imageUrl)).then((response) async {
    final bytes = response.bodyBytes;
    await file.writeAsBytes(bytes);
  });

  return file;
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');
  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return file;
}

goTerms(BuildContext context) =>
    Navigator.push(context, SlideRightRoute(page: const TermsAndConditions()));

goToRecovery(BuildContext context) =>
    Navigator.push(context, SlideRightRoute(page: const PasswordRecovery()));

goToRegister(BuildContext context) =>
    Navigator.push(context, SlideRightRoute(page: const Register()));

goToLogin(BuildContext context) =>
    Navigator.push(context, SlideRightRoute(page: const Login()));

goToProfile(BuildContext context) => Navigator.push(
      context,
      SlideRightRoute(page: const ProfileUser()),
    );

goToRegisterPlant(BuildContext context) =>
    Navigator.push(context, SlideRightRoute(page: const RegisterPlant()));
