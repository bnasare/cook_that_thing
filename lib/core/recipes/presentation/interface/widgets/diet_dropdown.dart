import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/shared/utils/validator.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class DietDropdown extends StatelessWidget {
  final void Function(String?) onChanged;

  final diet = ValueNotifier<String?>(null);

  DietDropdown({super.key, required this.onChanged});

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
          value: diet.value?.isEmpty ?? true ? null : diet.value,
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
            labelText: 'Diet',
            hintText: 'Type of diet',
          ),
          menuMaxHeight: 100,
          items: [
            DropdownMenuItem<String?>(
                value: null,
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Type of diet'))),
            DropdownMenuItem<String?>(
                value: 'Vegan',
                child: Transform.translate(
                    offset: const Offset(-15, 0), child: const Text('Vegan'))),
            DropdownMenuItem<String?>(
                value: 'Vegetarian',
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Vegetarian'))),
            DropdownMenuItem<String?>(
                value: 'Gluten-free',
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Gluten-free'))),
            DropdownMenuItem<String?>(
                value: 'Low-Carb',
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Low-Carb'))),
            DropdownMenuItem<String?>(
                value: 'Protein',
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Protein'))),
          ],
          onChanged: (newValue) {
            diet.value = newValue;
          },
        ),
      ),
    );
  }
}
