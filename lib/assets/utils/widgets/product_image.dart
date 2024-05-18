import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class ProductImage extends StatelessWidget {
  final String? urlPath;
  const ProductImage({
    super.key,
    this.urlPath,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: 250,
        height: 250,
        child: ClipRRect(
          borderRadius: borderRadius20,
          child: _getImage(urlPath),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: borderRadius20,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Widget _getImage(String? urlPath) {
    if (urlPath == null) {
      return Image.asset(
        Assets.no_image,
        fit: BoxFit.cover,
      );
    }
    return Image.file(File(urlPath), fit: BoxFit.cover);
  }
}
