import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

class AppStyledText extends StatelessWidget {
  const AppStyledText({super.key, required this.text, this.isCentered = false});

  final String text;
  final bool isCentered;

  @override
  Widget build(BuildContext context) {
    return StyledText(
      text: text,
      textAlign: isCentered ? TextAlign.center : TextAlign.left,
      tags: {
        'bold':
            StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
        'medium':
            StyledTextTag(style: const TextStyle(fontWeight: FontWeight.w500)),
        'blue': StyledTextTag(style: const TextStyle(color: Colors.blue)),
        'black': StyledTextTag(style: const TextStyle(color: Colors.black)),
        'darkBlue': StyledTextTag(style: const TextStyle(color: Colors.black)),
        'h1': StyledTextTag(style: const TextStyle(fontSize: 20)),
        'h2': StyledTextTag(style: const TextStyle(fontSize: 16)),
      },
    );
  }
}
