// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/models/comment_models.dart';
import 'package:planta_tracker/pages/home/home.dart';
import 'package:planta_tracker/services/plants_services.dart';

class Comments extends StatefulWidget {
  final int id;
  const Comments({super.key, required this.id});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  CommentModels comentario = CommentModels();
  OptionPlantServices sendComments = OptionPlantServices();
  final GlobalKey<FormState> formKey = GlobalKey();
  final comment = TextEditingController();
  String comments = '';

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

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
          'Añadir comentario',
          style: context.theme.textTheme.titleApBar,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: allPadding24,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: comment,
                maxLines: 12,
                maxLength: 150,
                textAlign: TextAlign.justify,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Escriba su comentario aqui...',
                  labelText: 'Escriba su comentario aqui...',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PlantaColors.colorGreen),
                    borderRadius: borderRadius10,
                  ),
                ),
                onChanged: (value) {
                  comment.text = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!.obligatory_camp;
                  }
                  return null;
                },
              ),
              verticalMargin16,
              ButtomLarge(
                color: PlantaColors.colorGreen,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      comments = comment.text;
                    });

                    warning(context, '¿Esta seguro de enviar su comentario?',
                        () async {
                      EasyLoading.show();

                      comentario.id = widget.id.toString();
                      comentario.notas = comments;

                      try {
                        var res = await sendComments.addComment(comentario);

                        switch (res!.statusCode) {
                          case 200:
                            log('Mision Cumplida');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorGreen,
                              content: Center(
                                child: AutoSizeText(
                                  'Sucessfully post',
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
                                    color: PlantaColors.colorWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ));
                            EasyLoading.dismiss();
                            if (!context.mounted) return;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              Navigator.push(
                                  context, SlideRightRoute(page: const Home()));
                            });
                            break;
                          case 406:
                            EasyLoading.dismiss();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  'Repetitive Post',
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
                                    color: PlantaColors.colorWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ));
                            break;
                          case 400:
                            EasyLoading.dismiss();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  res.body,
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
                                    color: PlantaColors.colorWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ));
                            break;
                          case 401:
                            EasyLoading.dismiss();
                            Navigator.pop(context);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  res.body,
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
                                    color: PlantaColors.colorWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ));
                            break;
                          default:
                            EasyLoading.dismiss();
                            Navigator.pop(context);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  res.body,
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
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
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: PlantaColors.colorOrange,
                          content: Center(
                            child: AutoSizeText(
                              'Sin conexión',
                              style: context.theme.textTheme.text_01.copyWith(
                                color: PlantaColors.colorWhite,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ));
                      }
                    });
                  }
                },
                title: 'Enviar',
              )
            ],
          ),
        ),
      ),
    );
  }
}
