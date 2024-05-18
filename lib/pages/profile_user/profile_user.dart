import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/models/user_models.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/assets/utils/widgets/language.dart';
import 'package:planta_tracker/services/user_services.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  UserServices userServices = UserServices();

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
          AppLocalizations.of(context)!.user_profile,
          style: context.theme.textTheme.titleApBar,
        ),
      ),
      body: FutureBuilder(
        future: userServices.getUserDetails(context),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            EasyLoading.show();
            return Container();
          } else {
            EasyLoading.dismiss();
            return _UserProfile(user: snapshot.data!);
          }
        },
      ),
    );
  }
}

class _UserProfile extends StatefulWidget {
  final User user;
  const _UserProfile({required this.user});

  @override
  State<_UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<_UserProfile> {
  final password = TextEditingController();
  final name = TextEditingController();
  final passwordConfirm = TextEditingController();
  bool visibility = true;
  bool visibilityConfirm = true;
  bool disabledPassword = false;
  bool disabledName = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: allPadding16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 2, child: SizedBox()),
            Center(
              child: Icon(
                Ionicons.person_circle_outline,
                size: 140.0,
                color: PlantaColors.colorBlack,
              ),
            ),
            verticalMargin12,
            disabledName
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: AutoSizeText(
                          widget.user.fullName,
                          style: context.theme.textTheme.h2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      horizontalMargin8,
                      GestureDetector(
                        onTap: () {
                          warning(
                            context,
                            '¿Esta seguro de cambiar el nombre?',
                            () {
                              setState(() {
                                disabledName = false;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: Icon(
                          Ionicons.pencil_outline,
                          color: PlantaColors.colorBlack,
                        ),
                      ),
                    ],
                  )
                : TextFormField(
                    controller: name,
                    obscureText: false,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecorations.authInputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: PlantaColors.colorGreen),
                        borderRadius: borderRadius10,
                      ),
                      hintText: AppLocalizations.of(context)!.enter_full_name,
                      labelText: AppLocalizations.of(context)!.full_name,
                      icon: Icon(
                        Ionicons.person_sharp,
                        color: PlantaColors.colorGreen,
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
            verticalMargin24,
            AutoSizeText(
              'Correo: ${widget.user.email}',
              style: context.theme.textTheme.text_01,
            ),
            verticalMargin12,
            Row(
              children: [
                AutoSizeText(
                  'Cambiar lenguaje:',
                  style: context.theme.textTheme.text_01,
                ),
                horizontalMargin12,
                Container(
                  width: 80.0,
                  height: 40.0,
                  // padding: allPadding12,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius10,
                    border: Border.all(
                      color: PlantaColors.colorOrange,
                    ),
                  ),
                  child: const LanguagePickerWidget(),
                ),
              ],
            ),
            verticalMargin12,
            const Divider(),
            verticalMargin12,
            Row(
              children: [
                AutoSizeText(
                  'Contraseña',
                  style: context.theme.textTheme.text_01,
                ),
                horizontalMargin8,
                GestureDetector(
                  onTap: () {
                    warning(
                      context,
                      '¿Esta seguro de cambiar contraseña?',
                      () {
                        setState(() {
                          disabledPassword = true;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Icon(
                    Ionicons.pencil_outline,
                    color: PlantaColors.colorBlack,
                    size: 20.0,
                  ),
                ),
              ],
            ),
            verticalMargin12,
            TextFormField(
              enabled: disabledPassword,
              controller: password,
              obscureText: false,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: PlantaColors.colorGreen),
                  borderRadius: borderRadius10,
                ),
                hintText: AppLocalizations.of(context)!.password_enter,
                labelText: AppLocalizations.of(context)!.password,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      visibility = !visibility;
                    });
                  },
                  icon: visibility
                      ? Icon(
                          Ionicons.eye_off_outline,
                          color: disabledPassword
                              ? PlantaColors.colorGreen
                              : PlantaColors.colorGrey,
                        )
                      : Icon(
                          Ionicons.eye_outline,
                          color: PlantaColors.colorGreen,
                        ),
                ),
                icon: Icon(
                  Ionicons.key_outline,
                  color: disabledPassword
                      ? PlantaColors.colorGreen
                      : PlantaColors.colorGrey,
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
            verticalMargin12,
            TextFormField(
              enabled: disabledPassword,
              controller: passwordConfirm,
              obscureText: visibilityConfirm,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: PlantaColors.colorGreen),
                  borderRadius: borderRadius10,
                ),
                hintText: AppLocalizations.of(context)!.enter_password_confirm,
                labelText: AppLocalizations.of(context)!.password_confirm,
                icon: Icon(
                  Ionicons.key_outline,
                  color: disabledPassword
                      ? PlantaColors.colorGreen
                      : PlantaColors.colorGrey,
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
                          color: disabledPassword
                              ? PlantaColors.colorGreen
                              : PlantaColors.colorGrey,
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
            const Expanded(flex: 5, child: SizedBox()),
            ButtomLarge(
              color: changeColor(),
              onTap: () {
                setState(() {
                  disabledName = true;
                  disabledPassword = false;
                });
              },
              title: 'Guardar',
            ),
          ],
        ),
      ),
    );
  }

  Color changeColor() {
    if (!disabledName) {
      return PlantaColors.colorGreen;
    } else if (disabledPassword) {
      return PlantaColors.colorGreen;
    }
    return PlantaColors.colorGrey;
  }
}
