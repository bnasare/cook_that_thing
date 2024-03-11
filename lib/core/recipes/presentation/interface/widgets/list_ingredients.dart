import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/custom_textfeld.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/validator.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';

// ignore: must_be_immutable
class ListIngredients extends HookWidget {
  TextEditingController ingredientsController = useTextEditingController();
  ValueNotifier<List<String>> submittedIngredients = useState<List<String>>([]);

  ListIngredients({
    super.key,
    required this.ingredientsController,
    required this.submittedIngredients,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: ingredientsController,
          labelText: 'Ingredients',
          hintText: 'List of ingredients',
          validator: (value) {
            return Validator.recipeIngredientsList(submittedIngredients.value);
          },
          textInputAction: TextInputAction.done,
          maxLines: 1,
          onFieldSubmitted: (String value) {
            final newIngredients = List<String>.from(submittedIngredients.value)
              ..add(value);
            submittedIngredients.value = newIngredients;
            ingredientsController.clear();
          },
        ),
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 7),
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: submittedIngredients.value.isNotEmpty ? 7 : 0,
            right: 25,
            left: 25,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: submittedIngredients.value.length,
          itemBuilder: (context, index) {
            final ingredient = submittedIngredients.value[index];
            final ingredientNumber = index + 1;
            return SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '$ingredientNumber. $ingredient',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: ExtraColors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Clickable(
                    onClick: () {
                      final newIngredients =
                          List<String>.from(submittedIngredients.value)
                            ..removeAt(index);
                      submittedIngredients.value = newIngredients;
                    },
                    child: Icon(
                      CupertinoIcons.trash_fill,
                      size: 16,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
