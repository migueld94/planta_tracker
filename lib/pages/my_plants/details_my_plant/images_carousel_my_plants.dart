import 'dart:io';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/models/plantas_hive.dart';

class ViewImageMyPlantsCarousel extends StatefulWidget {
  final int id;
  final List<ImagesMyPlant>? posterPath;
  final int initialPage;
  const ViewImageMyPlantsCarousel({
    super.key,
    required this.id,
    required this.posterPath,
    required this.initialPage,
  });

  @override
  State<ViewImageMyPlantsCarousel> createState() =>
      _ViewImageMyPlantsCarouselState();
}

class _ViewImageMyPlantsCarouselState extends State<ViewImageMyPlantsCarousel> {
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
                final images = widget.posterPath![index];
                final fileName = images.posterPath!.split('/').last;

                if (fileName.endsWith("De7au1t.png")) {
                  return SizedBox.shrink();
                }
                return ClipRRect(
                  borderRadius: borderRadius10,
                  child: Image.file(
                    File(images.posterPath!),
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
