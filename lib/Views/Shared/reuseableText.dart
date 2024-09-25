import 'package:flutter/material.dart';

class ReUseAbleText extends StatelessWidget {
  const ReUseAbleText({super.key, required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      // textAlign: TextAlign.left,
      softWrap: true,
      style: style,
    );
  }
}
