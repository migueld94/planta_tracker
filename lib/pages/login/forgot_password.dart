// ignore_for_file: use_build_context_synchronously

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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/pages/login/verify_code_02.dart';
import 'package:planta_tracker/services/auth_services.dart';

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({super.key});

  @override
  State<PasswordRecovery> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  String email = '';
  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  AutoSizeText(
                    AppLocalizations.of(context)!.recover_password,
                    style: context.theme.textTheme.h1,
                  ),
                  verticalMargin16,
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(color: PlantaColors.colorBlack),
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
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.obligatory_camp;
                      }
                      return null;
                    },
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
                  verticalMargin16,
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
                        setState(() {
                          email = emailController.text;
                        });

                        EasyLoading.show();
                        var res = await authService.forgotPassword(email);

                        switch (res!.statusCode) {
                          case 200:
                            EasyLoading.dismiss();
                            Navigator.push(
                              context,
                              SlideRightRoute(page: VerifyCode02(email: email)),
                            );
                            break;
                          case 400:
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Registro fallido"),
                            ));
                            break;
                          default:
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Verificacion fallida"),
                            ));
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
      ),
    );
  }
}
