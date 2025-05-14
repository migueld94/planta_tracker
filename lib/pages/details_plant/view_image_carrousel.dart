import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/circular_progress.dart';
import 'package:planta_tracker/models/details_models.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';

class ViewImageCarousel extends StatefulWidget {
  final int id;
  final List<Imagene>? posterPath;
  final int initialPage;
  const ViewImageCarousel({
    super.key,
    required this.id,
    required this.posterPath,
    required this.initialPage,
  });

  @override
  State<ViewImageCarousel> createState() => _ViewImageCarouselState();
}

class _ViewImageCarouselState extends State<ViewImageCarousel> {
  // final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          AppLocalizations.of(context)!.carousel,
          style: context.theme.textTheme.titleApBar,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider.builder(
              // carouselController: _controller,
              itemCount: widget.posterPath!.length,
              itemBuilder: (context, index, realIndex) {
                return ClipRRect(
                  borderRadius: borderRadius10,
                  child: CachedNetworkImage(
                    filterQuality: FilterQuality.high,
                    imageUrl:
                        '${Constants.baseUrl}${widget.posterPath?[index].posterPath}',
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularPlantaTracker()),
                    errorWidget:
                        (context, url, error) => Icon(
                          Ionicons.image_sharp,
                          color: PlantaColors.colorBlack,
                        ),
                    fit: BoxFit.cover,
                  ),
                );
              },
              options: CarouselOptions(
                height: 400,
                initialPage: widget.initialPage,
                viewportFraction: 0.6,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                enlargeFactor: 0.5,
                scrollDirection: Axis.horizontal,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                enlargeCenterPage: true,
              ),
            ),
            verticalMargin16,
            AutoSizeText(
              '<= ${AppLocalizations.of(context)!.slide} =>',
              style: context.theme.textTheme.text_01.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
