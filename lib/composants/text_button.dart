import 'package:flutter/material.dart';
import 'package:todo/composants/my_text.dart';

class TextButtons extends StatefulWidget {
  final void Function()? onPressed;
  final String text;
  final Color? backgroundColor;
  final OutlinedBorder? shape;
  final Color? color;

  const TextButtons(
      {super.key,
      this.onPressed,
      required this.text,
      this.backgroundColor,
      this.shape,
      this.color});

  @override
  State<TextButtons> createState() => _TextButtonsState();
}

class _TextButtonsState extends State<TextButtons> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        shape: widget.shape,
      ),
      onPressed: widget.onPressed,
      child: MyText(
        text: widget.text,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: widget.color,
      ),
    );
  }
}
