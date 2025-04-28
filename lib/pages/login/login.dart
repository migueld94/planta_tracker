// ignore_for_file: avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';

import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:planta_tracker/pages/home/home.dart';
import 'package:planta_tracker/services/auth_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
  final GlobalKey<FormState> formKey = GlobalKey();
  String emails = '';
  String passwords = '';
  final email = TextEditingController();
  final password = TextEditingController();
  bool visibility = true;

  void checkToken() async {
    var token = await storage.read(key: "token");
    if (token != null) {
      Navigator.push(context, FadeTransitionRoute(page: const Home()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: allPadding16,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                        AppLocalizations.of(context)!.log_in,
                        style: context.theme.textTheme.h1,
                      ),
                    ),
                    verticalMargin24,
                    TextFormField(
                      controller: email,
                      decoration: InputDecorations.authInputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: PlantaColors.colorGreen),
                          borderRadius: borderRadius10,
                        ),
                        hintText: AppLocalizations.of(context)!.email_enter,
                        labelText: AppLocalizations.of(context)!.email,
                        icon: Icon(
                          Ionicons.mail_outline,
                          color: PlantaColors.colorGreen,
                        ),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return AppLocalizations.of(context)!.obligatory_camp;
                        } else {
                          return EmailValidator.validate(value.trim())
                              ? null
                              : AppLocalizations.of(context)!.enter_email_valid;
                        }
                      },
                    ),
                    verticalMargin24,
                    TextFormField(
                      controller: password,
                      obscureText: visibility,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecorations.authInputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: PlantaColors.colorGreen),
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
                                  color: PlantaColors.colorGreen,
                                )
                              : Icon(
                                  Ionicons.eye_outline,
                                  color: PlantaColors.colorGreen,
                                ),
                        ),
                        icon: Icon(
                          Ionicons.key_outline,
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
                    verticalMargin24,
                    GestureDetector(
                      onTap: () {
                        goToRecovery(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AutoSizeText(
                            AppLocalizations.of(context)!.forget,
                            style: context.theme.textTheme.text_01,
                          ),
                          horizontalMargin8,
                          AutoSizeText(
                            AppLocalizations.of(context)!.recover,
                            style: context.theme.textTheme.text_01.copyWith(
                              color: PlantaColors.colorGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalMargin24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AutoSizeText(
                          AppLocalizations.of(context)!.account,
                          style: context.theme.textTheme.text_01,
                        ),
                        horizontalMargin8,
                        GestureDetector(
                          onTap: () async {
                            goToRegister(context);
                          },
                          child: AutoSizeText(
                            AppLocalizations.of(context)!.register,
                            style: context.theme.textTheme.text_01
                                .copyWith(color: PlantaColors.colorGreen),
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    ButtomLarge(
                      color: PlantaColors.colorGreen,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          setState(() {
                            emails = email.text;
                            passwords = password.text;
                          });

                          EasyLoading.show();
                          try {
                            var res = await authService.login(
                                email.text.trim(), password.text);

                            switch (res!.statusCode) {
                              case 200:
                                EasyLoading.dismiss();
                                var data = jsonDecode(res.body);
                                await storage.write(
                                    key: "token", value: data['token']);

                                await storage.write(
                                  key: "refresh_token",
                                  value: data['refresh_token'],
                                );
                                if (!context.mounted) return;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  Navigator.push(context,
                                      SlideRightRoute(page: const Home()));
                                });
                                break;
                              case 400:
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: PlantaColors.colorOrange,
                                  content: Center(
                                    child: AutoSizeText(
                                      AppLocalizations.of(context)!
                                          .verify_credentials,
                                      style: context.theme.textTheme.text_01
                                          .copyWith(
                                        color: PlantaColors.colorWhite,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ));
                                break;
                              case 401:
                                EasyLoading.dismiss();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: PlantaColors.colorOrange,
                                  content: Center(
                                    child: AutoSizeText(
                                      AppLocalizations.of(context)!
                                          .verify_credentials,
                                      style: context.theme.textTheme.text_01
                                          .copyWith(
                                        color: PlantaColors.colorWhite,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ));
                                break;
                              default:
                                EasyLoading.dismiss();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: PlantaColors.colorOrange,
                                  content: Center(
                                    child: AutoSizeText(
                                      AppLocalizations.of(context)!
                                          .verify_credentials,
                                      style: context.theme.textTheme.text_01
                                          .copyWith(
                                        color: PlantaColors.colorWhite,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ));
                                break;
                            }
                          } on SocketException {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  AppLocalizations.of(context)!.no_internet,
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
                                    color: PlantaColors.colorWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ));
                          } catch (e) {
                            EasyLoading.dismiss();
                            throw Exception(e);
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
        ),
      ),
    );
  }
}
