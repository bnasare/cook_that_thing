// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/validator.dart';

import '../widgets/custom_textfeld.dart';

class CreateRecipePage extends HookWidget {
  const CreateRecipePage({super.key});
  @override
  Widget build(BuildContext context) {
    final category = useState<String?>(null);
    final diet = useState<String>('');
    final titleController = useTextEditingController();
    final ingredientsController = useTextEditingController();
    final instructionsController = useTextEditingController();
    final overviewController = useTextEditingController();
    final timeController = useTextEditingController();
    final servingsController = useTextEditingController();
    final formKey = GlobalKey<FormState>();

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(title: const Text('New Recipe')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: titleController,
                  labelText: 'Title',
                  hintText: 'Title of your recipe',
                  validator: Validator.recipeTitle,
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: overviewController,
                  labelText: 'Overview',
                  hintText: 'A brief description of your recipe',
                  validator: Validator.recipeOverview,
                  maxLines: null,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
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
                          value: category.value?.isEmpty ?? true
                              ? null
                              : category.value,
                          validator: Validator.recipeCategory,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: ExtraColors.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 0, right: 10, top: 10, bottom: 10),
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
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: false,
                            label: Transform.translate(
                              offset: const Offset(120, 0),
                              child: const Text(
                                'Meal',
                                style: TextStyle(
                                    fontSize: 22, color: ExtraColors.black),
                              ),
                            ),
                            hintText: 'Type of meal',
                          ),
                          menuMaxHeight: 100,
                          items: const [
                            DropdownMenuItem<String?>(
                                value: null, child: Text('Type of meal')),
                            DropdownMenuItem<String?>(
                                value: 'Breakfast', child: Text('Breakfast')),
                            DropdownMenuItem<String?>(
                                value: 'Lunch', child: Text('Lunch')),
                            DropdownMenuItem<String?>(
                                value: 'Dinner', child: Text('Dinner')),
                            DropdownMenuItem<String?>(
                                value: 'Dessert', child: Text('Dessert')),
                            DropdownMenuItem<String?>(
                                value: 'Main', child: Text('Main')),
                            DropdownMenuItem<String?>(
                                value: 'Snacks', child: Text('Snacks')),
                          ],
                          onChanged: (newValue) {
                            category.value = newValue;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          icon: const Icon(IconlyBold.arrow_down_2, size: 18),
                          isExpanded: true,
                          isDense: true,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: ExtraColors.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 20, right: 10, top: 10, bottom: 10),
                            labelStyle: const TextStyle(
                                fontSize: 22, color: ExtraColors.black),
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
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: false,
                            labelText: 'Diet',
                            hintText: 'Type of diet',
                          ),
                          menuMaxHeight: 100,
                          items: const [
                            DropdownMenuItem(
                                value: 'Vegan', child: Text('Vegan')),
                            DropdownMenuItem(
                                value: 'Vegetarian', child: Text('Vegetarian')),
                            DropdownMenuItem(
                                value: 'Ketogenic', child: Text('Ketogenic')),
                            DropdownMenuItem(
                                value: 'Paleo', child: Text('Paleo')),
                            DropdownMenuItem(
                                value: 'Low-Carb', child: Text('Low-Carb')),
                            DropdownMenuItem(
                                value: 'Mediterranean',
                                child: Text('Mediterranean')),
                          ],
                          onChanged: (value) {
                            diet.value = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
