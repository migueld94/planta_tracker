import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/drop_buttom.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/pages/home/home.dart';

class RegisterPlantEnd extends StatefulWidget {
  const RegisterPlantEnd({super.key});

  @override
  RegisterPlantEndState createState() => RegisterPlantEndState();
}

class RegisterPlantEndState extends State<RegisterPlantEnd> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final note = TextEditingController();

  @override
  void dispose() {
    note.dispose();
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
          AppLocalizations.of(context)!.plant_register,
          style: context.theme.textTheme.titleApBar,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: allPadding24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Aquí va tu lista horizontal de cámaras
              SizedBox(
                height: 150, // Ajusta la altura según necesites
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      5, // Asegúrate de usar la cantidad correcta de elementos
                  itemBuilder: (context, index) {
                    int i = index;
                    List<String> nombres = [
                      AppLocalizations.of(context)!.plant_register_full_image,
                      AppLocalizations.of(context)!.plant_register_trunk_image,
                      AppLocalizations.of(context)!
                          .plant_register_image_branches,
                      AppLocalizations.of(context)!.plant_register_sheet_image,
                      AppLocalizations.of(context)!.plant_register_fruit_image,
                    ];
                    return Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              padding: allPadding32,
                              margin: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                              ),
                              decoration: BoxDecoration(
                                color: PlantaColors.colorWhite,
                                borderRadius: borderRadius10,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(5, 7),
                                    blurRadius: 12,
                                    color: PlantaColors.colorBlack
                                        .withOpacity(0.3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Ionicons.camera_outline,
                                size: 30,
                                color: PlantaColors.colorOrange,
                              ),
                            ),
                            verticalMargin12,
                            AutoSizeText(nombres[i],
                                style: context.theme.textTheme.text_01),
                          ],
                        ),
                        Positioned(
                          left: 75,
                          bottom: 115,
                          child: IconButton(
                            icon: const Icon(Icons.loop_rounded),
                            color: PlantaColors.colorLightRed,
                            onPressed: () {
                              // Acción al presionar el botón de editar
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              //DropdownButton
              const MyDropButtom(),
              verticalMargin16,
              //TextField para las notas
              AutoSizeText('Notas', style: context.theme.textTheme.h2),
              verticalMargin8,
              TextFormField(
                controller: note,
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
                  note.text = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!.obligatory_camp;
                  }
                  return null;
                },
              ),
              // const Expanded(child: SizedBox()),
              verticalMargin16,

              ButtomLarge(
                  color: PlantaColors.colorGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  title: AppLocalizations.of(context)!.text_buttom_next),
            ],
          ),
        ),
      ),
    );
  }
}
