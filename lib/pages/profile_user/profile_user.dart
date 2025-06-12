// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/widgets/circular_progress.dart';
import 'package:planta_tracker/blocs/profile/profile_bloc.dart';
import 'package:planta_tracker/blocs/profile/profile_event.dart';
import 'package:planta_tracker/blocs/profile/profile_state.dart';
import 'package:planta_tracker/models/user_models.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/assets/utils/widgets/language.dart';
import 'package:planta_tracker/pages/home/home.dart';
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
          onTap:
              () =>
                  Navigator.push(context, FadeTransitionRoute(page: const Home())),
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
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularPlantaTracker());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return _UserProfile(user: profile);
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Ionicons.wifi_outline,
                    size: 90.0,
                    color: PlantaColors.colorGrey,
                  ),
                  Text(
                    AppLocalizations.of(context)!.error_connection,
                    style: context.theme.textTheme.h2.copyWith(
                      color: PlantaColors.colorGrey,
                      fontSize: 20.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(FetchProfile());
                    },
                    icon: Icon(Ionicons.refresh_outline, size: 30.0),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _UserProfile extends StatefulWidget {
  final User? user;
  const _UserProfile({required this.user});

  @override
  State<_UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<_UserProfile> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final UserServices userServices = UserServices();
  final storage = const FlutterSecureStorage();
  final GlobalKey<FormState> formKeyName = GlobalKey();
  final GlobalKey<FormState> formKeyPassword = GlobalKey();
  final GlobalKey<FormState> formKeyPasswordConfirm = GlobalKey();

  String fullName = '';
  String password = '';
  String passwordConfirm = '';
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
                        widget.user!.fullName,
                        style: context.theme.textTheme.h2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    horizontalMargin8,
                    GestureDetector(
                      onTap: () {
                        warning(
                          context,
                          AppLocalizations.of(context)!.message_change_name,
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
                : Form(
                  key: formKeyName,
                  child: TextFormField(
                    controller: nameController,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.obligatory_camp;
                      }
                      return null;
                    },
                  ),
                ),
            verticalMargin24,
            AutoSizeText(
              '${AppLocalizations.of(context)!.email}: ${widget.user!.email}',
              style: context.theme.textTheme.text_01,
            ),
            verticalMargin12,
            Row(
              children: [
                AutoSizeText(
                  AppLocalizations.of(context)!.select_languages,
                  style: context.theme.textTheme.text_01,
                ),
                horizontalMargin12,
                Container(
                  width: 80.0,
                  height: 40.0,
                  // padding: allPadding12,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius10,
                    border: Border.all(color: PlantaColors.colorOrange),
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
                  AppLocalizations.of(context)!.password,
                  style: context.theme.textTheme.text_01,
                ),
                horizontalMargin8,
                GestureDetector(
                  onTap: () {
                    warning(
                      context,
                      AppLocalizations.of(context)!.message_change_password,
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
            Form(
              key: formKeyPassword,
              child: TextFormField(
                enabled: disabledPassword,
                controller: passwordController,
                obscureText: visibility,
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
                    icon:
                        visibility
                            ? Icon(
                              Ionicons.eye_off_outline,
                              color:
                                  disabledPassword
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
                    color:
                        disabledPassword
                            ? PlantaColors.colorGreen
                            : PlantaColors.colorGrey,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!.obligatory_camp;
                  }
                  return null;
                },
              ),
            ),
            verticalMargin12,
            Form(
              key: formKeyPasswordConfirm,
              child: TextFormField(
                enabled: disabledPassword,
                controller: passwordConfirmController,
                obscureText: visibilityConfirm,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecorations.authInputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PlantaColors.colorGreen),
                    borderRadius: borderRadius10,
                  ),
                  hintText:
                      AppLocalizations.of(context)!.enter_password_confirm,
                  labelText: AppLocalizations.of(context)!.password_confirm,
                  icon: Icon(
                    Ionicons.key_outline,
                    color:
                        disabledPassword
                            ? PlantaColors.colorGreen
                            : PlantaColors.colorGrey,
                  ),
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        visibilityConfirm = !visibilityConfirm;
                      });
                    },
                    icon:
                        visibilityConfirm
                            ? Icon(
                              Ionicons.eye_off_outline,
                              color:
                                  disabledPassword
                                      ? PlantaColors.colorGreen
                                      : PlantaColors.colorGrey,
                            )
                            : Icon(
                              Ionicons.eye_outline,
                              color: PlantaColors.colorGreen,
                            ),
                  ),
                ),
                validator: (value2) {
                  if (value2!.isEmpty) {
                    return AppLocalizations.of(context)!.obligatory_camp;
                  }
                  return null;
                },
              ),
            ),
            const Expanded(flex: 5, child: SizedBox()),
            ButtomLarge(
              color: changeColor(),
              onTap: () async {
                //* AQUI_SE CAMBIA EL NOMBRE
                if (!disabledName) {
                  if (formKeyName.currentState!.validate()) {
                    formKeyName.currentState!.save();

                    EasyLoading.show();
                    setState(() {
                      fullName = nameController.text;
                    });

                    try {
                      var res = await userServices.changeName(
                        context,
                        fullName,
                      );

                      switch (res.statusCode) {
                        case 200:
                          EasyLoading.dismiss();

                          if (!context.mounted) return;

                          context.read<ProfileBloc>().add(
                            ProfileInvalidateCache(),
                          );
                          context.read<ProfileBloc>().add(FetchProfile());

                          setState(() {
                            disabledName = true;
                          });
                          Navigator.pop(context);

                          break;
                        case 400:
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  AppLocalizations.of(
                                    context,
                                  )!.verify_credentials,
                                  style: context.theme.textTheme.text_01
                                      .copyWith(
                                        color: PlantaColors.colorWhite,
                                        fontSize: 16.0,
                                      ),
                                ),
                              ),
                            ),
                          );
                          break;
                        case 401:
                          EasyLoading.dismiss();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  AppLocalizations.of(
                                    context,
                                  )!.verify_credentials,
                                  style: context.theme.textTheme.text_01
                                      .copyWith(
                                        color: PlantaColors.colorWhite,
                                        fontSize: 16.0,
                                      ),
                                ),
                              ),
                            ),
                          );
                          break;
                        default:
                          EasyLoading.dismiss();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  // 'Credenciales incorrectas',
                                  AppLocalizations.of(
                                    context,
                                  )!.verify_credentials,

                                  style: context.theme.textTheme.text_01
                                      .copyWith(
                                        color: PlantaColors.colorWhite,
                                        fontSize: 16.0,
                                      ),
                                ),
                              ),
                            ),
                          );
                          break;
                      }
                    } on SocketException {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: PlantaColors.colorOrange,
                          content: Center(
                            child: AutoSizeText(
                              // 'Sin conexión',
                              AppLocalizations.of(context)!.no_internet,

                              style: context.theme.textTheme.text_01.copyWith(
                                color: PlantaColors.colorWhite,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    } catch (e) {
                      EasyLoading.dismiss();
                      throw Exception(e);
                    }
                  }
                }

                //* AQUI_SE CAMBIA EL PASSWORD
                if (disabledPassword) {
                  if ((formKeyPassword.currentState!.validate()) &&
                      (formKeyPasswordConfirm.currentState!.validate())) {
                    formKeyPassword.currentState!.save();
                    formKeyPasswordConfirm.currentState!.save();

                    if (passwordController.text.toLowerCase() ==
                        passwordConfirmController.text.toLowerCase()) {
                      EasyLoading.show();
                      setState(() {
                        password = passwordController.text;
                        passwordConfirm = passwordConfirmController.text;
                      });

                      try {
                        var res = await userServices.changePassword(
                          context,
                          password,
                          passwordConfirm,
                        );

                        switch (res.statusCode) {
                          case 200:
                            EasyLoading.dismiss();

                            if (!context.mounted) return;
                            context.read<ProfileBloc>().add(
                              ProfileInvalidateCache(),
                            );
                            context.read<ProfileBloc>().add(FetchProfile());
                            setState(() {
                              disabledPassword = false;
                            });
                            Navigator.pop(context);

                            break;
                          case 400:
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: PlantaColors.colorOrange,
                                content: Center(
                                  child: AutoSizeText(
                                    // 'Credenciales incorrectas',
                                    AppLocalizations.of(
                                      context,
                                    )!.verify_credentials,
                                    style: context.theme.textTheme.text_01
                                        .copyWith(
                                          color: PlantaColors.colorWhite,
                                          fontSize: 16.0,
                                        ),
                                  ),
                                ),
                              ),
                            );
                            break;
                          case 401:
                            EasyLoading.dismiss();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: PlantaColors.colorOrange,
                                content: Center(
                                  child: AutoSizeText(
                                    // 'Credenciales incorrectas',
                                    AppLocalizations.of(
                                      context,
                                    )!.verify_credentials,
                                    style: context.theme.textTheme.text_01
                                        .copyWith(
                                          color: PlantaColors.colorWhite,
                                          fontSize: 16.0,
                                        ),
                                  ),
                                ),
                              ),
                            );
                            break;
                          default:
                            EasyLoading.dismiss();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: PlantaColors.colorOrange,
                                content: Center(
                                  child: AutoSizeText(
                                    // 'Credenciales incorrectas',
                                    AppLocalizations.of(
                                      context,
                                    )!.verify_credentials,
                                    style: context.theme.textTheme.text_01
                                        .copyWith(
                                          color: PlantaColors.colorWhite,
                                          fontSize: 16.0,
                                        ),
                                  ),
                                ),
                              ),
                            );
                            break;
                        }
                      } on SocketException {
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: PlantaColors.colorOrange,
                            content: Center(
                              child: AutoSizeText(
                                // 'Sin conexión',
                                AppLocalizations.of(context)!.no_internet,
                                style: context.theme.textTheme.text_01.copyWith(
                                  color: PlantaColors.colorWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      } catch (e) {
                        EasyLoading.dismiss();
                        throw Exception(e);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: PlantaColors.colorDarkOrange,
                          content: Center(
                            child: AutoSizeText(
                              AppLocalizations.of(context)!.password_match,
                              style: context.theme.textTheme.text_01.copyWith(
                                color: PlantaColors.colorWhite,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }
              },
              title: AppLocalizations.of(context)!.text_buttom_save,
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
