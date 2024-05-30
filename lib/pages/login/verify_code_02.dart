// ignore_for_file: use_build_context_synchronously

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
import 'package:planta_tracker/pages/login/change_password.dart';
import 'package:planta_tracker/pages/login/login.dart';
import 'package:planta_tracker/services/auth_services.dart';

class VerifyCode02 extends StatefulWidget {
  const VerifyCode02({
    required this.email,
    super.key,
  });
  final String email;

  @override
  State<VerifyCode02> createState() => _VerifyCode02State();
}

class _VerifyCode02State extends State<VerifyCode02> {
  String otp = '';
  Timer? timer;
  int countDown = 60;
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
        countDown = 60;
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
          padding: allPadding24,
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
                  'Verificar código',
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
                  decimal()
                      ? AutoSizeText(
                          '00 : 0${countDown.toString()}',
                          style: context.theme.textTheme.text_01,
                        )
                      : AutoSizeText(
                          '00 : ${countDown.toString()}',
                          style: context.theme.textTheme.text_01,
                        ),
                  Row(
                    children: [
                      AutoSizeText(
                        "No he recibido el código.",
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
                                  .showSnackBar(const SnackBar(
                                content: Text("Registro fallido"),
                              ));
                              break;
                            default:
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Verificacion fallida"),
                              ));
                              break;
                          }
                        },
                        child: AutoSizeText(
                          'Reenviar',
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
                        SlideRightRoute(
                            page: ChangePassword(
                          email: widget.email,
                          otp: otp,
                        )),
                      );
                      break;
                    case 400:
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Registro fallido"),
                      ));
                      break;
                    default:
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Verificacion fallida"),
                      ));
                      break;
                  }
                },
                title: 'Enviar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
