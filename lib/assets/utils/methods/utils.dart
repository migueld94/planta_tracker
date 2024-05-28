// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/pages/home/home.dart';
import 'package:planta_tracker/pages/login/change_password.dart';
import 'package:planta_tracker/pages/login/forgot_password.dart';
import 'package:planta_tracker/pages/login/login.dart';
import 'package:planta_tracker/pages/login/register.dart';
import 'package:flutter/material.dart';
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

goToHome(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );

goTerms(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TermsAndConditions(),
      ),
    );

goToRecovery(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PasswordRecovery(),
    ));

goToRegister(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const Register(),
    ));

goToLogin(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const Login(),
    ));

goToProfile(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileUser(),
      ),
    );

goToRegisterPlant(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPlant(),
      ),
    );

goToChangePassword(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePassword(),
      ),
    );