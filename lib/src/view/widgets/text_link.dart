import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final Text? text;
  final String? str;
  final TextStyle? style;
  final VoidCallback onTap;

  const TextLink(
    String text, {
    required this.onTap,
    this.style,
    super.key,
  })  : str = text,
        text = null;

  const TextLink.text({
    required Text this.text,
    required this.onTap,
    super.key,
  })  : str = null,
        style = null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: text ?? Text(str!, style: style),
      ),
    );
  }
}
