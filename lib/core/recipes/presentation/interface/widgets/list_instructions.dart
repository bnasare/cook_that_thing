import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/custom_textfeld.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/validator.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';

// ignore: must_be_immutable
class ListInstructions extends HookWidget {
  TextEditingController instructionsController = useTextEditingController();
  ValueNotifier<List<String>> submittedInstructions =
      useState<List<String>>([]);

  ListInstructions({
    super.key,
    required this.instructionsController,
    required this.submittedInstructions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: instructionsController,
          labelText: 'Instructions',
          hintText: 'List of instructions',
          validator: (value) {
            return Validator.recipeInstructionsList(
                submittedInstructions.value);
          },
          textInputAction: TextInputAction.done,
          maxLines: 2,
          onFieldSubmitted: (String value) {
            final newInstructions =
                List<String>.from(submittedInstructions.value)..add(value);
            submittedInstructions.value = newInstructions;
            instructionsController.clear();
          },
        ),
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 7),
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: submittedInstructions.value.isNotEmpty ? 7 : 0,
            right: 25,
            left: 25,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: submittedInstructions.value.length,
          itemBuilder: (context, index) {
            final ingredient = submittedInstructions.value[index];
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
                      final newInstructions =
                          List<String>.from(submittedInstructions.value)
                            ..removeAt(index);
                      submittedInstructions.value = newInstructions;
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
