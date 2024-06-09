import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/presentation/widgets/shimmer.dart';
import '../../bloc/recipe_mixin.dart';
import 'recipe_info_item.dart';

class ReviewButton extends HookWidget with RecipeMixin {
  final String recipeID;
  ReviewButton(this.recipeID, {super.key});

  @override
  Widget build(BuildContext context) {
    final reviewsNotifier = useState<int?>(null);

    useEffect(() {
      final subscription = fetchReviewsByRecipeID(context, recipeID).listen(
        (reviews) {
          reviewsNotifier.value = reviews.length;
        },
        onError: (error) {
          log('Error fetching reviews: $error');
          reviewsNotifier.value = 0;
        },
      );
      return subscription.cancel;
    }, [recipeID]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Material(
        color: ExtraColors.white,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                  stream: getAverageReviewsRatingStream(recipeID, context),
                  builder: (context, snapshot) {
                    return RecipeInfoItem(
                        icon: Icons.grade,
                        text: snapshot.data?.toStringAsFixed(1) ?? '0.0',
                        iconColor: ExtraColors.yellow,
                        textColor: ExtraColors.grey);
                  }),
              const SizedBox(width: 1),
              reviewsNotifier.value == null
                  ? const LoadingTextView(width: 7, height: 7)
                  : Text(
                      '(${reviewsNotifier.value.toString()} ${reviewsNotifier.value == 1 ? 'Review' : 'Reviews'})',
                      style: const TextStyle(
                          color: ExtraColors.grey, fontSize: 16),
                    ),
              const SizedBox(width: 3),
            ],
          ),
        ),
      ),
    );
  }
}
