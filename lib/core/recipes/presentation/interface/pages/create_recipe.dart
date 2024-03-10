// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/category_dropdown.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/diet_dropdown.dart';
import 'package:recipe_hub/shared/utils/validator.dart';

import '../widgets/custom_textfeld.dart';

class CreateRecipePage extends HookWidget {
  const CreateRecipePage({super.key});
  @override
  Widget build(BuildContext context) {
    final category = useState<String?>(null);
    final diet = useState<String?>(null);
    final titleController = useTextEditingController();
    final ingredientsController = useTextEditingController();
    final instructionsController = useTextEditingController();
    final overviewController = useTextEditingController();
    final timeController = useTextEditingController();
    final servingsController = useTextEditingController();
    final formKey = GlobalKey<FormState>();

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
                maxLines: null,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryDropdown(
                    onChanged: (newValue) {
                      category.value = newValue;
                    },
                  ),
                  const SizedBox(width: 20),
                  DietDropdown(onChanged: (newValue) {
                    diet.value = newValue;
                  }),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
