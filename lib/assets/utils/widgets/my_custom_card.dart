import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class MyCustomCard extends StatelessWidget {
  final String title;
  final Function()? onTap;
  // final String lifestage;
  // final String status;

  const MyCustomCard({
    super.key,
    required this.title,
    required this.onTap,
    // required this.lifestage,
    // required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                // titulo
                Expanded(
                  child: AutoSizeText(
                    title,
                    style: context.theme.textTheme.h3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // verticalMargin8,
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Row(
          //     children: [
          //       Container(
          //         width: 85.0,
          //         height: 30.0,
          //         decoration: BoxDecoration(
          //           borderRadius: borderRadius20,
          //           color: PlantaColors.colorDarkGreen,
          //         ),
          //         child: Center(
          //           child: AutoSizeText(
          //             status,
          //             style: context.theme.textTheme.text_02
          //                 .copyWith(color: PlantaColors.colorWhite),
          //           ),
          //         ),
          //       ),
          //       horizontalMargin4,
          //       Container(
          //         width: 85.0,
          //         height: 30.0,
          //         decoration: BoxDecoration(
          //           borderRadius: borderRadius20,
          //           border: Border.all(
          //             color: PlantaColors.colorOrange,
          //           ),
          //         ),
          //         child: Center(
          //           child: AutoSizeText(
          //             lifestage,
          //             style: context.theme.textTheme.text_02,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
