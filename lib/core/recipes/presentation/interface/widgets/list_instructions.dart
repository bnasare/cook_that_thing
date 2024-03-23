import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/custom_textfeld.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/validator.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';

class ListInstructions extends StatefulWidget {
  final TextEditingController instructionsController;
  final List<String> submittedInstructions;

  const ListInstructions({
    super.key,
    required this.instructionsController,
    required this.submittedInstructions,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ListInstructionsState createState() => _ListInstructionsState();
}

class _ListInstructionsState extends State<ListInstructions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: widget.instructionsController,
          labelText: 'Instructions',
          hintText: 'List of instructions',
          validator: (value) {
            return Validator.recipeInstructionsList(
                widget.submittedInstructions);
          },
          textInputAction: TextInputAction.done,
          maxLines: 2,
          onFieldSubmitted: (String value) {
            setState(() {
              widget.submittedInstructions.add(value);
              widget.instructionsController.clear();
            });
          },
        ),
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 7),
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: widget.submittedInstructions.isNotEmpty ? 7 : 0,
            right: 25,
            left: 25,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.submittedInstructions.length,
          itemBuilder: (context, index) {
            final instruction = widget.submittedInstructions[index];
            final instructionNumber = index + 1;
            return SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '$instructionNumber. $instruction',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: ExtraColors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Clickable(
                    onClick: () {
                      setState(() {
                        widget.submittedInstructions.removeAt(index);
                      });
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
