import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../core/recipes/presentation/interface/pages/recipe_details.dart';
import '../../../../../core/recipes/presentation/interface/widgets/recipe_info.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/presentation/widgets/clickable.dart';
import '../../../../../shared/presentation/widgets/error_view.dart';
import '../../../../../shared/presentation/widgets/shimmer.dart';
import '../../../../../shared/presentation/widgets/snackbar.dart';
import '../../../../../shared/presentation/widgets/warning_modal.dart';

class FavoritesPage extends HookWidget with ChefMixin {
  FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalRecipes = useState<int?>(null);

    final favoriteRecipes = useMemoized(() => fetchFavorites(context));

    useEffect(() {
      final StreamSubscription<List<Recipe>> subscription =
          favoriteRecipes.listen((favoriteRecipes) {
        totalRecipes.value = favoriteRecipes.length;
      }, onError: (error) {
        debugPrint(error.toString());
      });

      return subscription.cancel;
    }, []);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text('Favorites (${totalRecipes.value})'),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  if (totalRecipes.value == null || totalRecipes.value! <= 0) {
                    SnackBarHelper.showErrorSnackBar(
                        context, 'Nothing to delete');
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return WarningModal(
                          title: "Clear All Favorites",
                          content:
                              "Are you sure you want to clear all favorite recipes?",
                          primaryButtonLabel: "YES",
                          primaryAction: () {
                            clearFavoriteRecipes();
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    IconlyLight.delete,
                    color: Theme.of(context).colorScheme.primary,
                    size: 23,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                  shrinkWrap: true,
                  children: [
                    StreamBuilder<List<Recipe>>(
                      stream: fetchFavoritess(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 100.0),
                            child: ErrorViewWidget(),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 20, top: 20),
                            itemBuilder: (BuildContext context, int index) {
                              return const LoadingTextView(
                                  height: 130, width: double.infinity);
                            },
                            itemCount: snapshot.data?.length ?? 5,
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          // Add this condition to handle no data or an empty list
                          return const Padding(
                            padding: EdgeInsets.only(top: 100.0),
                            child: ErrorViewWidget(),
                          );
                        } else if (snapshot.hasData) {
                          // If there's data, build a list of RecipeInfo widgets
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Recipe recipe = snapshot.data![index];
                              return Clickable(
                                onClick: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return RecipeDetailsPage(
                                          recipeID: recipe.id);
                                    },
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
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
                            padding: EdgeInsets.only(top: 100.0),
                            child: ErrorViewWidget(),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
