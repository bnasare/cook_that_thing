import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';

class ListIngredients extends StatefulWidget {
  final TextEditingController ingredientsController;
  final List<String> submittedIngredients;

  const ListIngredients({
    super.key,
    required this.ingredientsController,
    required this.submittedIngredients,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ListIngredientsState createState() => _ListIngredientsState();
}

class _ListIngredientsState extends State<ListIngredients> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textInputAction: TextInputAction.done,
          controller: widget.ingredientsController,
          decoration: const InputDecoration(
            filled: true,
            hintText: 'Add an ingredient',
          ),
          onSubmitted: (String value) {
            setState(() {
              widget.submittedIngredients.add(value);
              widget.ingredientsController.clear();
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
