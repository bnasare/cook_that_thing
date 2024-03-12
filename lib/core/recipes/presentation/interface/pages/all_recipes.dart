import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/recipes/presentation/bloc/recipe_mixin.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';
import '../../../domain/entities/recipe.dart';
import '../widgets/recipe_grid_widget.dart';

class AllRecipesPage extends HookWidget with RecipeMixin {
  AllRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final totalRecipes = useState<int?>(null);

    Future<void> fetchTotalRecipes() async {
      try {
        final List<Recipe> allRecipes = await fetchAllRecipes(context).first;
        totalRecipes.value = allRecipes.length;
      } catch (error) {
        debugPrint(error.toString());
      }
    }

    useEffect(() {
      fetchTotalRecipes();
      return () {};
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(localizations.allRecipes)),
      body: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            title: Text(
              '${totalRecipes.value != null ? ' ${totalRecipes.value}' : '0'} ${totalRecipes.value == 1 ? localizations.recipeInTotalSingular : localizations.recipeInTotalPlural} ',
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
                StreamBuilder(
                    stream: fetchAllRecipes(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        // If there's an error, return the error widget.
                        return const ErrorViewWidget();
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        // If the connection is still waiting, show a loading indicat
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return const LoadingTextView(height: 25);
                          },
                          itemCount: 8,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  crossAxisCount: 2),
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        // If there's data but the list is empty, show a "no data" me
                        return const ErrorViewWidget();
                      } else if (snapshot.hasData) {
                        // If there's data, return the RecipeGridWidget.
                        return RecipeGridWidget(recipes: snapshot.data!);
                      } else {
                        // If the snapshot is neither loading, with error, nor with d
                        return const ErrorViewWidget();
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
