import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtomSmall(
                    color: PlantaColors.colorOrange,
                    onTap: () => Navigator.of(context).pop,
                    title: AppLocalizations.of(context)!.text_buttom_denied,
                  ),
                  horizontalMargin16,
                  ButtomSmall(
                    color: PlantaColors.colorGreen,
                    onTap: () => warning(
                      context,
                      '¿Esta seguro de enviar su comentario?',
                      () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            comments = comment.text;
                          });
                          goToDetails(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: PlantaColors.colorGreen,
                              content: Center(
                                child: AutoSizeText(
                                  'Comentario publicado con exito',
                                  style:
                                      context.theme.textTheme.messengerScaffold,
                                ),
                              ),
                            ),
                          );
                        } else {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  'No ha realizado el comentario',
                                  style:
                                      context.theme.textTheme.messengerScaffold,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    title: AppLocalizations.of(context)!.text_buttom_accept,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
