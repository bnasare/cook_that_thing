import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/pages/recipe_details.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../widgets/recipe_grid_widget.dart';

class AllRecipesPage extends HookWidget {
  const AllRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final totalRecipes = useState<int?>(null);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(localizations.allRecipes)),
      body: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            title: Text(
              '${totalRecipes.value != null ? ' (${totalRecipes.value})' : '0'} ${totalRecipes.value == 1 ? localizations.recipeInTotalSingular : localizations.recipeInTotalPlural} ',
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
              children: [
                Clickable(
                    onClick: () {
                      NavigationHelper.navigateTo(
                          context, const RecipeDetailsPage(recipeID: ''));
                    },
                    child: const RecipeGridWidget())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
