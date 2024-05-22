import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/models/policies_models.dart';
import 'package:planta_tracker/services/policies_services.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  final PoliciesServices policiesServices = PoliciesServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlantaColors.colorGreen,
        centerTitle: true,
        iconTheme: IconThemeData(color: PlantaColors.colorWhite),
        title: AutoSizeText(
          AppLocalizations.of(context)!.terms_conditions,
          style: context.theme.textTheme.titleApBar,
        ),
      ),
      body: FutureBuilder(
        future: policiesServices.getPolicies(context),
        builder: (context, AsyncSnapshot<PoliciesModels> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return PoliciesWidget(snapshot.data!.results);
          }
        },
      ),
    );
  }
}

class PoliciesWidget extends StatefulWidget {
  final List<Result> policies;
  const PoliciesWidget(this.policies, {super.key});

  @override
  State<PoliciesWidget> createState() => _PoliciesWidgetState();
}

class _PoliciesWidgetState extends State<PoliciesWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: allPadding16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.policies.length,
              itemBuilder: (context, index) => Html(
                data: widget.policies[index].descripcion,
                style: {
                  "p": Style(
                    color: PlantaColors.colorBlack,
                    textAlign: TextAlign.justify,
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
