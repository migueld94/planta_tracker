import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class SquaredIconButton extends StatelessWidget {
  const SquaredIconButton(
      {super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: 35,
            child: Ink(
              decoration: const BoxDecoration(
                borderRadius: borderRadius5,
              ),
            ),
          ),
          Icon(
            icon,
            size: 17,
          ),
        ],
      ),
    );
  }
}
