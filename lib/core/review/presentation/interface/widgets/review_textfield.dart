import 'package:flutter/material.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';

class ReviewTextField extends StatelessWidget {
  const ReviewTextField({
    super.key,
    required this.controller,
    required this.validator,
    required this.onEditingComplete,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      onEditingComplete: onEditingComplete,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
          fontSize: 14, color: ExtraColors.grey, fontWeight: FontWeight.w500),
      textAlignVertical: TextAlignVertical.top,
      maxLines: 12,
      decoration: InputDecoration(
        labelText: 'Review',
        labelStyle: const TextStyle(fontSize: 22, color: ExtraColors.black),
        alignLabelWithHint: true,
        contentPadding:
            const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 10),
        hintText: 'Describe your experience',
        hintStyle: const TextStyle(
            fontSize: 14,
            color: ExtraColors.darkGrey,
            fontWeight: FontWeight.w500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ExtraColors.darkGrey.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ExtraColors.darkGrey,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: false,
      ),
    );
  }
}
