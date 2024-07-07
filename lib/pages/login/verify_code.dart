// ignore_for_file: avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/style.dart';
import 'package:planta_tracker/pages/login/login.dart';
import 'package:planta_tracker/services/auth_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({
    required this.email,
    super.key,
  });
  final String email;

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  String otp = '';
  Timer? timer;
  int countDown = 240;
  bool canResend = false;
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countDown > 0) {
          countDown--;
        } else {
          canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void resendOtp() {
    if (canResend) {
      setState(() {
        countDown = 240;
        canResend = false;
        startTimer();
      });
    }
  }

  bool decimal() {
    if (countDown < 10) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: allPadding16,
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
                  AppLocalizations.of(context)!.verify_code,
                  style: context.theme.textTheme.h1,
                ),
              ),
              verticalMargin24,
              OTPTextField(
                fieldWidth: 50.0,
                fieldStyle: FieldStyle.box,
                length: 6,
                keyboardType: TextInputType.number,
                otpFieldStyle: OtpFieldStyle(
                  enabledBorderColor: PlantaColors.colorGreen,
                ),
                width: MediaQuery.of(context).size.width,
                style: context.theme.textTheme.text_01,
                textFieldAlignment: MainAxisAlignment.spaceBetween,
                onChanged: (pin) {
                  otp = pin;
                },
              ),
              verticalMargin24,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    '${(countDown ~/ 60).toString().padLeft(2, '0')} : ${(countDown % 60).toString().padLeft(2, '0')}',
                    style: context.theme.textTheme.text_01,
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        AppLocalizations.of(context)!.no_receive_code,
                        style: context.theme.textTheme.text_01
                            .copyWith(color: PlantaColors.colorGrey),
                      ),
                      horizontalMargin4,
                      GestureDetector(
                        onTap: () async {
                          EasyLoading.show();
                          var res = await authService
                              .resendCodeActivatition(widget.email);

                          switch (res!.statusCode) {
                            case 200:
                              EasyLoading.dismiss();
                              break;
                            case 400:
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: AutoSizeText(
                                  AppLocalizations.of(context)!.sign_up_failed,
                                  style: context.theme.textTheme.text_01,
                                ),
                              ));
                              break;
                            default:
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
                        },
                        child: AutoSizeText(
                          AppLocalizations.of(context)!.text_buttom_resend,
                          style: context.theme.textTheme.text_01.copyWith(
                            color: canResend
                                ? PlantaColors.colorGreen
                                : PlantaColors.colorGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              ButtomLarge(
                color: PlantaColors.colorGreen,
                onTap: () async {
                  EasyLoading.show();
                  var res = await authService.verifyCode(widget.email, otp);

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
                            AppLocalizations.of(context)!.verify_code_failed,
                            style: context.theme.textTheme.text_01,
                          ),
                        ),
                      );
                      break;
                  }
                },
                title: AppLocalizations.of(context)!.text_buttom_send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
