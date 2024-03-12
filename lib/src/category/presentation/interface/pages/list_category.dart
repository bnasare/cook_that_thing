import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recipe_hub/shared/data/image_assets.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';
import 'package:recipe_hub/src/category/presentation/interface/pages/category_page.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<String> assets = [
      ImageAssets.breakfast,
      ImageAssets.lunch,
      ImageAssets.dinner,
      ImageAssets.dessert,
      ImageAssets.snacks,
    ];

    final List<String> categories = [
      localizations.breakfast,
      localizations.lunch,
      localizations.dinner,
      localizations.dessert,
      localizations.snacks,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '${assets.length} Categories',
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ExtraColors.black,
                    fontSize: 17),
              ),
              subtitle: const Text(
                'Available in stock',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: ExtraColors.grey,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      return Clickable(
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RecipeCategoryPage(
                                    category: categories[index]);
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 150,
                                width: 160,
                                child: Image.asset(
                                  assets[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(categories[index],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
