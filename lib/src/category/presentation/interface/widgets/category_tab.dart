import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recipe_hub/src/category/presentation/interface/widgets/category_widget.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: SizedBox(
        height: 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CategoryWidget(
              category: localizations.breakfast,
            ),
            const SizedBox(width: 10),
            CategoryWidget(
              category: localizations.lunch,
            ),
            const SizedBox(width: 10),
            CategoryWidget(
              category: localizations.dinner,
            ),
            const SizedBox(width: 10),
            CategoryWidget(
              category: localizations.dessert,
            ),
            const SizedBox(width: 10),
            CategoryWidget(
              category: localizations.snacks,
            ),
          ],
        ),
      ),
    );
  }
}
