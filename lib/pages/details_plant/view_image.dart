import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class ViewImage extends StatelessWidget {
  final int id;
  final String posterPath;
  final String type;
  const ViewImage({
    super.key,
    required this.id,
    required this.posterPath,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(type, style: context.theme.textTheme.titleApBar),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: id,
              child: Container(
                margin: allMargin16,
                decoration: BoxDecoration(
                  borderRadius: borderRadius10,
                  color: PlantaColors.colorWhite,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(5, 7),
                      blurRadius: 10,
                      color: PlantaColors.colorBlack.withOpacity(0.3),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: borderRadius10,
                  child: CachedNetworkImage(
                    filterQuality: FilterQuality.low,
                    imageUrl: posterPath,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(
                        Ionicons.image_sharp,
                        color: PlantaColors.colorBlack),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
