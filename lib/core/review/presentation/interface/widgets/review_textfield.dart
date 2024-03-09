import 'package:flutter/material.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';

class ReviewTextField extends StatelessWidget {
  const ReviewTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.contentPadding,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hintText;
  final EdgeInsetsGeometry contentPadding;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlignVertical: TextAlignVertical.top,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        filled: true,
        fillColor: ExtraColors.lightGrey,
        hintText: hintText,
        hintStyle: const TextStyle(color: ExtraColors.grey, fontSize: 15),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
