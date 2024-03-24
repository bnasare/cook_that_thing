import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/recipes/presentation/bloc/recipe_mixin.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/pages/recipe_details.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';

import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../core/recipes/presentation/interface/widgets/recipe_info.dart';
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
                      StreamBuilder<List<Recipe>>(
                        stream: fetchAllRecipesByCategory(context, category),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 90.0),
                              child: ErrorViewWidget(),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: LoadingTextView(
                                  height: 116, width: double.infinity),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 90.0),
                              child: ErrorViewWidget(),
                            );
                          } else if (snapshot.hasData) {
                            // If there's data, build a list of RecipeInfo widgets
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Recipe recipe = snapshot.data![index];
                                return Clickable(
                                  onClick: () => NavigationHelper.navigateTo(
                                      context,
                                      RecipeDetailsPage(recipeID: recipe.id)),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ExtraColors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: ExtraColors.darkGrey
                                                .withOpacity(0.4),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(3, 3),
                                          )
                                        ]),
                                    child: RecipeInfo(
                                      recipe: recipe,
                                      recipeID: recipe.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.only(top: 90.0),
                              child: ErrorViewWidget(),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
