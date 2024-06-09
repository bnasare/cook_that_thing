// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/presentation/widgets/clickable.dart';

class ListIngredients extends StatefulWidget {
  final TextEditingController ingredientsController;
  final List<String> submittedIngredients;

  const ListIngredients({
    super.key,
    required this.ingredientsController,
    required this.submittedIngredients,
  });

  @override
  _ListIngredientsState createState() => _ListIngredientsState();
}

class _ListIngredientsState extends State<ListIngredients> {
  bool showCheckIcon = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textInputAction: TextInputAction.done,
          controller: widget.ingredientsController,
          decoration: InputDecoration(
            filled: true,
            fillColor: ExtraColors.lightGrey,
            hintText: 'Tap the checkmark to submit each item',
            suffixIcon: Visibility(
              visible: showCheckIcon,
              child: IconButton(
                icon: const Icon(CupertinoIcons.check_mark_circled_solid,
                    color: ExtraColors.successLight),
                onPressed: () {
                  final value = widget.ingredientsController.text.trim();
                  if (value.isNotEmpty) {
                    setState(() {
                      widget.submittedIngredients.add(value);
                      widget.ingredientsController.clear();
                      showCheckIcon = false;
                    });
                  }
                },
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              showCheckIcon = value.isNotEmpty;
            });
          },
        ),
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 7),
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: widget.submittedIngredients.isNotEmpty ? 7 : 0,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.submittedIngredients.length,
          itemBuilder: (context, index) {
            final ingredient = widget.submittedIngredients[index];
            final ingredientNumber = index + 1;
            return SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '$ingredientNumber. $ingredient',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ExtraColors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Clickable(
                    onClick: () {
                      setState(() {
                        widget.submittedIngredients.removeAt(index);
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
