// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/category_dropdown.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/diet_dropdown.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/difficulty_dropdown.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/validator.dart';
import 'package:recipe_hub/shared/widgets/snackbar.dart';

import '../widgets/custom_textfeld.dart';
import '../widgets/list_ingredients.dart';
import '../widgets/list_instructions.dart';

class CreateRecipePage extends HookWidget {
  const CreateRecipePage({super.key});
  @override
  Widget build(BuildContext context) {
    final category = useState<String?>(null);
    final diet = useState<String?>(null);
    final difficultyLevel = useState<String?>(null);
    final submittedIngredients = useState<List<String>>([]);
    final submittedInstructions = useState<List<String>>([]);
    final duration = useState(const Duration(hours: 0, minutes: 0));
    final isLoading = useState(false);

    final titleController = useTextEditingController();
    final ingredientsController = useTextEditingController();
    final instructionsController = useTextEditingController();
    final overviewController = useTextEditingController();
    final durationController = useTextEditingController(text: '30min');

    final formKey = GlobalKey<FormState>();

    void submit() async {
      log('object');
    }

    return Scaffold(
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
                maxLines: 2,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryDropdown(
                    category: category,
                    onCategoryChanged: (newValue) {
                      category.value = newValue;
                    },
                  ),
                  const SizedBox(width: 20),
                  DietDropdown(
                    diet: diet,
                    onDietChanged: (newValue) {
                      diet.value = newValue;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ListIngredients(
                ingredientsController: ingredientsController,
                submittedIngredients: submittedIngredients,
              ),
              SizedBox(height: submittedIngredients.value.isNotEmpty ? 20 : 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final initialMinutes = int.tryParse(
                            durationController.text.split('min')[0]);
                        final initialTime =
                            Duration(minutes: initialMinutes ?? 30);
                        var resultingDuration = await showDurationPicker(
                          context: context,
                          initialTime: initialTime,
                        );
                        if (resultingDuration != null) {
                          final hours = resultingDuration.inHours;
                          final minutes =
                              resultingDuration.inMinutes.remainder(60);
                          final durationText = hours > 0
                              ? '${hours}h ${minutes}min'
                              : '${minutes}min';
                          final validationError =
                              Validator.validateTime(durationText);
                          if (validationError == null) {
                            duration.value = resultingDuration;
                            durationController.text = durationText;
                          } else {
                            SnackBarHelper.showErrorSnackBar(
                                context, validationError);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 25),
                        height: 49,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ExtraColors.transparent,
                          border: Border.all(
                            color: ExtraColors.darkGrey.withOpacity(0.5),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined,
                                color: ExtraColors.darkGrey, size: 20),
                            const SizedBox(width: 7),
                            Text(
                              durationController.text,
                              style: TextStyle(
                                fontSize: 16,
                                color: ExtraColors.grey.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  DifficultyLevelDropDown(
                    difficultyLevel: difficultyLevel,
                    onDifficultyLevelChanged: (newValue) {
                      difficultyLevel.value = newValue;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ListInstructions(
                instructionsController: instructionsController,
                submittedInstructions: submittedInstructions,
              ),
            ],
          ),
        )
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              submit();
            }
          },
          child: const Text('Create new recipe'),
        ),
      ),
    );
  }
}
