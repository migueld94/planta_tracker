// ignore_for_file: use_build_context_synchronously

import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({super.key});

  @override
  State<PasswordRecovery> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  String email = '';
  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  resetPassword() async {
    goToLogin(context);
  }

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
                    style: TextStyle(color: PlantaColors.colorBlack),
                    controller: emailController,
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
                    onChanged: (value) {
                      emailController.text = value;
                    },
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
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                        });
                        // goToVerifyCode(context);
                        // resetPassword();
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
