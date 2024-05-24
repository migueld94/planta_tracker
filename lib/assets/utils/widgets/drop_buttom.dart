import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planta_tracker/models/nom_lifestage.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/services/nom_lifestage_services.dart';

class MyDropButtom extends StatefulWidget {
  const MyDropButtom({
    super.key,
  });

  @override
  State<MyDropButtom> createState() => _MyDropButtomState();
}

class _MyDropButtomState extends State<MyDropButtom> {
  final LifestageServices lifestageServices = LifestageServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: lifestageServices.getLifestage(context),
      builder: (context, AsyncSnapshot<Lifestage> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return _NomLifestage(snapshot.data!.results);
        }
      },
    );
  }
}

class _NomLifestage extends StatefulWidget {
  final List<Result> lifestages;
  const _NomLifestage(this.lifestages);

  @override
  State<_NomLifestage> createState() => _NomLifestageState();
}

class _NomLifestageState extends State<_NomLifestage> {
  String? values;
  final storage = const FlutterSecureStorage();
  int life = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: PlantaColors.colorBlack),
        color: PlantaColors.colorWhite,
        borderRadius: borderRadius10,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: borderRadius10,
            ),
          ),
          isExpanded: true,
          hint: AutoSizeText(
            'Lifestage',
            style: context.theme.textTheme.text_01.copyWith(fontSize: 16.0),
          ),
          items: widget.lifestages.map((e) {
            return DropdownMenuItem(
              value: e.nombre,
              child: Text(e.nombre),
            );
          }).toList(),
          value: values,
          onChanged: (value) {
            setState(() {
              values = value;
              storage.write(key: "lifestage", value: values);
            });
          },
        ),
      ),
    );
  }
}
