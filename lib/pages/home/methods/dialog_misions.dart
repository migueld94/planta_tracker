import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

Future<void> showMisions(BuildContext context) {
  // Lista de misiones con ID
  final missions = List.generate(
    10,
    (index) => {
      'id': index,
      'name': 'Captura 100 Floralis Rara',
      'description':
          'Tu misión consiste en documentar la rareza de la Floralis Rara, una especie de planta única que florece en los bosques nubosos de la región andina. Esta planta es conocida por sus pétalos iridiscentes que cambian de color según la hora del día, creando un espectáculo visual impresionante.',
      'progress': 0.5,
      'prize': 'Botella Havana Club 7 Años',
    },
  );

  // Lista de expansión, inicialmente todos en false
  List<bool> isExpandedList = List.generate(missions.length, (index) => false);

  // Variable para el filtro seleccionado
  int selectedFilter = 1; // 1: Diaria, 2: Mensual, 3: Anual

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: borderRadius10),
            title: Text(
              'Misiones',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Filtro Diaria
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = 1;
                          });
                        },
                        child: Container(
                          padding: allMargin8,
                          decoration: BoxDecoration(
                            color:
                                selectedFilter == 1
                                    ? PlantaColors.colorOrange
                                    : Colors.transparent,
                            borderRadius: borderRadius10,
                            border: Border.all(color: PlantaColors.colorGreen),
                          ),
                          child: Text(
                            'Diaria',
                            style: context.theme.textTheme.text_01.copyWith(
                              color:
                                  selectedFilter == 1
                                      ? PlantaColors.colorWhite
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // Filtro Mensual
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = 2;
                          });
                        },
                        child: Container(
                          padding: allMargin8,
                          decoration: BoxDecoration(
                            color:
                                selectedFilter == 2
                                    ? PlantaColors.colorOrange
                                    : Colors.transparent,
                            borderRadius: borderRadius10,
                            border: Border.all(color: PlantaColors.colorGreen),
                          ),
                          child: Text(
                            'Mensual',
                            style: context.theme.textTheme.text_01.copyWith(
                              color:
                                  selectedFilter == 2
                                      ? PlantaColors.colorWhite
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // Filtro Anual
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = 3;
                          });
                        },
                        child: Container(
                          padding: allMargin8,
                          decoration: BoxDecoration(
                            color:
                                selectedFilter == 3
                                    ? PlantaColors.colorOrange
                                    : Colors.transparent,
                            borderRadius: borderRadius10,
                            border: Border.all(color: PlantaColors.colorGreen),
                          ),
                          child: Text(
                            'Anual',
                            style: context.theme.textTheme.text_01.copyWith(
                              color:
                                  selectedFilter == 3
                                      ? PlantaColors.colorWhite
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalMargin12,
                  Expanded(
                    child: ListView.builder(
                      itemCount: missions.length,
                      itemBuilder: (context, index) {
                        final percent =
                            (missions[index]['progress'] as double) * 100;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpandedList[index] = !isExpandedList[index];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: borderRadius10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        missions[index]['name'] as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isExpandedList[index]
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                if (isExpandedList[index]) ...[
                                  Row(
                                    spacing: 4.0,
                                    children: [
                                      Icon(Ionicons.attach_outline, size: 20.0),
                                      Text(
                                        'Descripción',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  verticalMargin8,
                                  Text(
                                    missions[index]['description'] as String,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  verticalMargin8,
                                  Row(
                                    spacing: 4.0,
                                    children: [
                                      Icon(
                                        Ionicons.diamond_outline,
                                        size: 20.0,
                                      ),
                                      Text(
                                        'Premio',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  verticalMargin8,
                                  Text(
                                    missions[index]['prize'] as String,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  verticalMargin8,
                                ],
                                LinearProgressIndicator(
                                  value: missions[index]['progress'] as double,
                                  borderRadius: borderRadius10,
                                ),
                                verticalMargin8,
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '${percent.toStringAsFixed(0)}%',
                                    style: context.theme.textTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
