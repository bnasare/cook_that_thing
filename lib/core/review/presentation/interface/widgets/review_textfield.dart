import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

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
          fontSize: 16, color: ExtraColors.grey, fontWeight: FontWeight.w500),
      textAlignVertical: TextAlignVertical.top,
      maxLines: 6,
      decoration: const InputDecoration(
        labelStyle: TextStyle(fontSize: 15, color: ExtraColors.darkGrey),
        alignLabelWithHint: true,
        contentPadding:
            EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        hintText: 'Add a detailed review of this recipe',
        hintStyle: TextStyle(
            fontSize: 16,
            color: ExtraColors.darkGrey,
            fontWeight: FontWeight.w500),
        filled: true,
        fillColor: ExtraColors.lightGrey,
      ),
    );
  }
}
