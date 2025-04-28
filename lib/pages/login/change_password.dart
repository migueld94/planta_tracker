// ignore_for_file: avoid_unnecessary_containers, use_build_context_synchronously

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/pages/login/login.dart';
import 'package:planta_tracker/services/auth_services.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  final String otp;
  const ChangePassword({required this.email, required this.otp, super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  String password = '';
  String passwordConfirm = '';
  bool visibility = true;
  bool visibilityConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: allPadding16,
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
                    AppLocalizations.of(context)!.change_password,
                    style: context.theme.textTheme.h1,
                  ),
                ),
                verticalMargin24,
                TextFormField(
                  controller: passwordController,
                  obscureText: visibility,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecorations.authInputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: PlantaColors.colorGreen),
                      borderRadius: borderRadius10,
                    ),
                    hintText: AppLocalizations.of(context)!.write_new_password,
                    labelText: AppLocalizations.of(context)!.new_password,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.obligatory_camp;
                    }
                    return null;
                  },
                ),
                verticalMargin16,
                TextFormField(
                  controller: passwordConfirmController,
                  obscureText: visibilityConfirm,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecorations.authInputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: PlantaColors.colorGreen),
                      borderRadius: borderRadius10,
                    ),
                    hintText: AppLocalizations.of(context)!.confirm_password,
                    labelText: AppLocalizations.of(context)!.confirm_password,
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
                  onTap: () async {
                    if (passwordController.text.toLowerCase() !=
                        passwordConfirmController.text.toLowerCase()) {
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
                      setState(() {
                        password = passwordController.text;
                        passwordConfirm = passwordConfirmController.text;
                      });

                      EasyLoading.show();
                      var res = await authService.changePassword(
                        widget.email.trim(),
                        password,
                        passwordConfirm,
                        widget.otp,
                      );

                      switch (res!.statusCode) {
                        case 200:
                          EasyLoading.dismiss();
                          Navigator.push(
                            context,
                            SlideRightRoute(page: const Login()),
                          );
                          break;
                        case 400:
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: AutoSizeText(
                                AppLocalizations.of(context)!.sign_up_failed,
                                style: context.theme.textTheme.text_01,
                              ),
                            ),
                          );
                          break;
                        default:
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: AutoSizeText(
                                AppLocalizations.of(context)!
                                    .verify_code_failed,
                                style: context.theme.textTheme.text_01,
                              ),
                            ),
                          );
                          break;
                      }
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
