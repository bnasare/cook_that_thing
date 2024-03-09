import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class SignUpTextfield extends StatelessWidget {
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final VoidCallback? onEditingComplete;
  final String hintText;
  final IconData prefixIcon;
  final ColorScheme color;

  const SignUpTextfield(
      {super.key,
      required this.keyboardType,
      this.validator,
      required this.controller,
      required this.textInputAction,
      this.onEditingComplete,
      required this.hintText,
      required this.prefixIcon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      controller: controller,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: color.error),
        filled: true,
        fillColor: ExtraColors.lightGrey,
        hintText: hintText,
        hintStyle: const TextStyle(color: ExtraColors.grey, fontSize: 15),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 10),
          child: Icon(
            prefixIcon,
            color: color.primary.withOpacity(0.6),
            size: 20,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
