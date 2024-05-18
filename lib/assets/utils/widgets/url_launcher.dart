import 'package:flutter/material.dart';

Widget launchButton({
  required String title,
  required IconData icon,
  required Function() onTap,
}) {
  return ElevatedButton(
    onPressed: onTap,
    child: Row(
      children: [
        Icon(icon),
        Text(title),
      ],
    ),
  );
}
