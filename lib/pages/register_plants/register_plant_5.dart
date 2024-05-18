import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/pages/register_plants/register_plant_end.dart';
import 'package:planta_tracker/pages/register_plants/widget/camera_widget.dart';

class RegisterPlant5 extends StatelessWidget {
  const RegisterPlant5({super.key});

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
      body: Center(
        child: CameraWidget(
          text: AppLocalizations.of(context)!.plant_register_fruit_image,
        ),
      ),
      bottomSheet: Padding(
        padding: allPadding24,
        child: ButtomLarge(
            color: PlantaColors.colorGreen,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterPlantEnd()),
              );
            },
            title: AppLocalizations.of(context)!.text_buttom_next),
      ),
    );
  }
}
