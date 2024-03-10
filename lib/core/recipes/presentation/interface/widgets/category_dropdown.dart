import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/shared/utils/validator.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class CategoryDropdown extends StatelessWidget {
  final ValueNotifier<String?> category;
  final Function(String?) onCategoryChanged;

  const CategoryDropdown({
    super.key,
    required this.category,
    required this.onCategoryChanged,
  });

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
          value: category.value?.isEmpty ?? true ? null : category.value,
          validator: Validator.recipeCategory,
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
            labelText: 'Meal',
            hintText: 'Type of meal',
          ),
          menuMaxHeight: 100,
          items: [
            DropdownMenuItem<String?>(
                value: null,
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Type of meal'))),
            DropdownMenuItem<String?>(
                value: 'Breakfast',
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Breakfast'))),
            DropdownMenuItem<String?>(
                value: 'Lunch',
                child: Transform.translate(
                    offset: const Offset(-15, 0), child: const Text('Lunch'))),
            DropdownMenuItem<String?>(
                value: 'Dinner',
                child: Transform.translate(
                    offset: const Offset(-15, 0), child: const Text('Dinner'))),
            DropdownMenuItem<String?>(
                value: 'Dessert',
                child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: const Text('Dessert'))),
            DropdownMenuItem<String?>(
                value: 'Main',
                child: Transform.translate(
                    offset: const Offset(-15, 0), child: const Text('Main'))),
            DropdownMenuItem<String?>(
                value: 'Snacks',
                child: Transform.translate(
                    offset: const Offset(-15, 0), child: const Text('Snacks'))),
          ],
          onChanged: (newValue) {
            onCategoryChanged(newValue);
          },
        ),
      ),
    );
  }
}
