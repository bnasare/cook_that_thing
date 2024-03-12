import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/recipes/presentation/bloc/recipe_mixin.dart';

import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../core/recipes/presentation/interface/widgets/recipe_grid_widget.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';

class RecipeCategoryPage extends HookWidget with RecipeMixin {
  final String category;

  RecipeCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final totalRecipes = useState<int?>(null);
    final localizations = AppLocalizations.of(context)!;

    Future<void> fetchTotalRecipes() async {
      try {
        final List<Recipe> allRecipes =
            await fetchAllRecipesByCategory(context, category).first;
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
      appBar: AppBar(title: Text(category)),
      body: StreamBuilder(
          stream: fetchAllRecipesByCategory(context, category),
          builder: (context, snapshot) {
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 20),
                  title: Text(
                    '${totalRecipes.value != null ? '${totalRecipes.value}' : ''} ${totalRecipes.value == 1 ? localizations.recipeFoundSingular : localizations.recipeFoundPlural}  ',
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
                          stream: fetchAllRecipesByCategory(context, category),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 90.0),
                                child: ErrorViewWidget(),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // If the connection is still waiting, show a loading indicat
                              return GridView.builder(
                                padding: const EdgeInsets.only(top: 20),
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
                            } else if (snapshot.hasData &&
                                snapshot.data!.isEmpty) {
                              // If there's data but the list is empty, show a "no data" me
                              return const Padding(
                                padding: EdgeInsets.only(top: 90.0),
                                child: ErrorViewWidget(),
                              );
                            } else if (snapshot.hasData) {
                              // If there's data, return the RecipeGridWidget.
                              return RecipeGridWidget(recipes: snapshot.data!);
                            } else {
                              return const Padding(
                                padding: EdgeInsets.only(top: 90.0),
                                child: ErrorViewWidget(),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
