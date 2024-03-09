import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final TextInputAction textInputAction;
  final int? maxLines;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textInputAction: textInputAction,
      style: const TextStyle(
          fontSize: 14, color: ExtraColors.grey, fontWeight: FontWeight.w500),
      maxLines: maxLines,
      minLines: 1,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 22, color: ExtraColors.black),
        alignLabelWithHint: true,
        contentPadding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        hintText: hintText,
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
