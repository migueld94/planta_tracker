import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_bloc.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_event.dart';
import 'package:planta_tracker/pages/my_plants/planta_enviada/planta_enviada_screen.dart';
import 'package:planta_tracker/pages/my_plants/planta_pendiente/planta_pendiente_screen.dart';

class MyPlants extends StatefulWidget {
  final Function(bool) onLoadingChanged;
  const MyPlants({super.key, required this.onLoadingChanged});

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants> {
  bool isSend = false;
  bool isPendient = true;

  @override
  Widget build(BuildContext context) {
    context.read<MyPlantsBloc>().add(LoadMyPlants());
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              selected: isSend,
              label: Text('Enviadas'),
              elevation: 1.0,
              selectedColor: Colors.green.withOpacity(0.3),
              onSelected: (value) {
                setState(() {
                  isSend = true;
                  isPendient = false;
                });
              },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              selected: isPendient,
              label: Text('Por Enviar'),
              elevation: 1.0,
              selectedColor: Colors.green.withOpacity(0.3),
              onSelected: (value) {
                setState(() {
                  isSend = false;
                  isPendient = true;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child:
              isPendient
                  ? PlantasPendientesScreen(
                    onLoadingChanged: widget.onLoadingChanged,
                  )
                  : const PlantsSentView(),
        ),
      ],
    );
  }
}
