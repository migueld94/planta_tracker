// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/pages/login/verify_code.dart';
import 'package:planta_tracker/services/auth_services.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> formKeyPassowrd = GlobalKey();
  final GlobalKey<FormState> formKeyPassowrdConfirm = GlobalKey();
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
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
      body: Center(
        child: SingleChildScrollView(
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
                      width: 220.0,
                    ),
                  ),
                  verticalMargin24,
                  AutoSizeText(
                    AppLocalizations.of(context)!.register,
                    style: context.theme.textTheme.h1,
                  ),
                  verticalMargin16,
                  TextFormField(
                    controller: name,
                    decoration: InputDecorations.authInputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: PlantaColors.colorGreen),
                        borderRadius: borderRadius10,
                      ),
                      hintText: AppLocalizations.of(context)!.enter_full_name,
                      labelText: AppLocalizations.of(context)!.full_name,
                      icon: Icon(
                        Ionicons.person,
                        color: PlantaColors.colorGreen,
                      ),
                      suffix: IconButton(
                        onPressed: () {
                          alert(context,
                              AppLocalizations.of(context)!.name_alert);
                        },
                        icon: Icon(
                          Ionicons.help_circle_outline,
                          color: PlantaColors.colorOrange,
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
                    controller: email,
                    decoration: InputDecorations.authInputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: PlantaColors.colorGreen),
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
                  verticalMargin16,
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
                      hintText: AppLocalizations.of(context)!.password_enter,
                      labelText: AppLocalizations.of(context)!.password,
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
                    controller: passwordConfirm,
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
                  verticalMargin8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        side: BorderSide(color: PlantaColors.colorGreen),
                        activeColor: PlantaColors.colorOrange,
                        value: valueTerms,
                        onChanged: (value) {
                          setState(() {
                            valueTerms = value!;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          goTerms(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              AppLocalizations.of(context)!.terms,
                              style: context.theme.textTheme.text_01,
                            ),
                            horizontalMargin8,
                            AutoSizeText(
                              AppLocalizations.of(context)!.see,
                              style: context.theme.textTheme.text_01.copyWith(
                                color: PlantaColors.colorGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // verticalMargin8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(AppLocalizations.of(context)!.account_accept,
                          style: context.theme.textTheme.text_01),
                      horizontalMargin8,
                      GestureDetector(
                        onTap: () {
                          goToLogin(context);
                        },
                        child: AutoSizeText(
                          AppLocalizations.of(context)!.log_in,
                          style: context.theme.textTheme.text_01.copyWith(
                            color: PlantaColors.colorGreen,
                          ),
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

                        if (valueTerms == false) {
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: PlantaColors.colorDarkOrange,
                            content: Center(
                              child: AutoSizeText(
                                // 'Acepte los términos y condiciones',
                                AppLocalizations.of(context)!.terms,
                                style: context.theme.textTheme.text_01.copyWith(
                                  color: PlantaColors.colorWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ));
                        } else if (password.text.toLowerCase() ==
                            passwordConfirm.text.toLowerCase()) {
                          EasyLoading.show();

                          var res = await authService.register(
                            email.text.trim(),
                            name.text,
                            password.text,
                            passwordConfirm.text,
                          );

                          switch (res!.statusCode) {
                            case 200:
                              EasyLoading.dismiss();
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                  page: VerifyCode(email: email.text.trim()),
                                ),
                              );
                              break;
                            case 400:
                              EasyLoading.dismiss();
                              // final parsedResponse = json.decode(res.body);
                              // final successValue = parsedResponse['data']['email'];
                              // var data = jsonDecode(res.body);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: PlantaColors.colorDarkOrange,
                                content: Center(
                                  child: AutoSizeText(
                                    'Registro Fallido',
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: PlantaColors.colorDarkOrange,
                                content: Center(
                                  child: AutoSizeText(
                                    'Registro Fallido',
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
                        } else {
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: PlantaColors.colorDarkOrange,
                            content: Center(
                              child: AutoSizeText(
                                'No coinciden las contraseñas',
                                style: context.theme.textTheme.text_01.copyWith(
                                  color: PlantaColors.colorWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ));
                        }
                      }
                    },
                    title: AppLocalizations.of(context)!.text_buttom_accept,
                  ),
                  // footer
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
