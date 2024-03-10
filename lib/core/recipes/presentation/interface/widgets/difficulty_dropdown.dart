import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/shared/utils/validator.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class DiifficultyLevelDropDown extends StatelessWidget {
  final void Function(String?) onChanged;

  final difficultyLevel = ValueNotifier<String?>(null);

  DiifficultyLevelDropDown({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String?>(
          style: TextStyle(
              fontSize: 14,
              color: ExtraColors.grey.withOpacity(0.7),
              fontWeight: FontWeight.w400),
          icon: const Icon(IconlyBold.arrow_down_2, size: 18),
          isExpanded: true,
          isDense: true,
          value: difficultyLevel.value?.isEmpty ?? true
              ? null
              : difficultyLevel.value,
          validator: Validator.recipeDiet,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              fontSize: 14,
              color: ExtraColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
            contentPadding:
                const EdgeInsets.only(left: 25, right: 20, top: 10, bottom: 10),
            labelStyle: const TextStyle(fontSize: 22, color: ExtraColors.black),
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
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: false,
            labelText: 'Difficulty',
            hintText: 'Difficulty of your recipe',
          ),
          menuMaxHeight: 100,
          items: [
            DropdownMenuItem<String?>(
                value: null,
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Difficulty'))),
            DropdownMenuItem<String?>(
                value: 'Beginner',
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Beginner'))),
            DropdownMenuItem<String?>(
                value: 'Intermediate',
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Intermediate'))),
            DropdownMenuItem<String?>(
                value: 'Advanced',
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Advanced'))),
          ],
          onChanged: (newValue) {
            difficultyLevel.value = newValue;
          },
        ),
      ),
    );
  }
}
