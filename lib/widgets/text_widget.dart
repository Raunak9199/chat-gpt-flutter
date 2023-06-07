import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String label;
  final double fontsize;
  final Color? color;
  final FontWeight? fontWeight;

  const TextWidget({
    super.key,
    required this.label,
    this.fontsize = 18,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontsize,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
