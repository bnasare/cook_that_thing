// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/pages/all_recipes.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_grid_widget.dart';
import 'package:recipe_hub/shared/data/svg_assets.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/src/category/presentation/interface/pages/list_category.dart';
import 'package:recipe_hub/src/category/presentation/interface/widgets/category_tab.dart';
import 'package:recipe_hub/src/home/presentation/interface/widgets/header.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: SvgPicture.asset(SvgAssets.logo, width: 200),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: ExtraColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: ExtraColors.darkGrey.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(localizations.discoverMore,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20)),
                          const SizedBox(height: 10),
                          Text(localizations.discoverSubtitle)
                        ],
                      ),
                    ),
                  ),
                  SvgPicture.asset(SvgAssets.book, width: 130)
                ],
              ),
            ),
            Header(
                leading: localizations.category,
                trailing: localizations.seeMore,
                onClick: () {
                  NavigationHelper.navigateTo(
                      context, const CategoryListPage());
                }),
            const CategoryTab(),
            Header(
                leading: localizations.proCook,
                trailing: localizations.seeMore,
                onClick: () {
                  NavigationHelper.navigateTo(context, const AllRecipesPage());
                }),
            const RecipeGridWidget(),
          ],
        ),
      ),
    );
  }
}
