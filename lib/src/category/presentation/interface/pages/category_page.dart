import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/recipes/presentation/interface/widgets/recipe_grid_widget.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';

class RecipeCategoryPage extends HookConsumerWidget {
  final String category;

  const RecipeCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalRecipes = useState<int?>(null);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            title: Text(
              '${totalRecipes.value != null ? ' (${totalRecipes.value})' : '0'} ${totalRecipes.value == 1 ? localizations.recipeFoundSingular : localizations.recipeFoundPlural}  ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: ExtraColors.grey,
                fontSize: 17,
              ),
            ),
            subtitle: const Text(
              'Enjoy your favorite recipes',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: ExtraColors.darkGrey,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              shrinkWrap: true,
              children: const [RecipeGridWidget()],
            ),
          ),
        ],
      ),
    );
  }
}
