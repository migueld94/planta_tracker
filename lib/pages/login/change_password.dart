// ignore_for_file: avoid_unnecessary_containers, use_build_context_synchronously

import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();
  bool valueTerms = false;
  bool visibility = true;
  bool visibilityConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: allPadding24,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                Center(
                  child: Image.asset(
                    Assets.logo,
                    fit: BoxFit.cover,
                    width: 256.0,
                  ),
                ),
                verticalMargin48,
                Center(
                  child: AutoSizeText(
                    'Cambiar contraseña',
                    style: context.theme.textTheme.h1,
                  ),
                ),
                verticalMargin24,
                TextFormField(
                  controller: password,
                  obscureText: visibility,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecorations.authInputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: PlantaColors.colorGreen),
                      borderRadius: borderRadius10,
                    ),
                    hintText: 'Ingrese su nueva contraseña',
                    labelText: 'Nueva contraseña',
                    icon: Icon(
                      Ionicons.key_outline,
                      color: PlantaColors.colorGreen,
                    ),
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          visibility = !visibility;
                        });
                      },
                      icon: visibility
                          ? Icon(
                              Ionicons.eye_off_outline,
                              color: PlantaColors.colorGreen,
                            )
                          : Icon(
                              Ionicons.eye_outline,
                              color: PlantaColors.colorGreen,
                            ),
                    ),
                  ),
                  onChanged: (value) {
                    password.text = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.obligatory_camp;
                    }
                    return null;
                  },
                ),
                verticalMargin16,
                TextFormField(
                  controller: passwordConfirm,
                  obscureText: visibilityConfirm,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecorations.authInputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: PlantaColors.colorGreen),
                      borderRadius: borderRadius10,
                    ),
                    hintText: 'Confirmar contraseña',
                    labelText: 'Confirmar contraseña',
                    icon: Icon(
                      Ionicons.key_outline,
                      color: PlantaColors.colorGreen,
                    ),
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          visibilityConfirm = !visibilityConfirm;
                        });
                      },
                      icon: visibilityConfirm
                          ? Icon(
                              Ionicons.eye_off_outline,
                              color: PlantaColors.colorGreen,
                            )
                          : Icon(
                              Ionicons.eye_outline,
                              color: PlantaColors.colorGreen,
                            ),
                    ),
                  ),
                  onChanged: (value) {
                    passwordConfirm.text = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.obligatory_camp;
                    }
                    return null;
                  },
                ),
                const Expanded(child: SizedBox()),
                ButtomLarge(
                  color: PlantaColors.colorGreen,
                  onTap: () {
                    if (password.text.toLowerCase() !=
                        passwordConfirm.text.toLowerCase()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: PlantaColors.colorOrange,
                          content: Center(
                            child: AutoSizeText(
                              AppLocalizations.of(context)!.password_match,
                              style: context.theme.textTheme.messengerScaffold,
                            ),
                          ),
                        ),
                      );
                    } else if (formKey.currentState!.validate()) {
                      goToLogin(context);
                      // setState(() {});
                      // _signup();
                    }
                  },
                  title: AppLocalizations.of(context)!.text_buttom_accept,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
