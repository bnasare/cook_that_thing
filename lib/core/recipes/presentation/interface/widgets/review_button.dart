import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/shimmer.dart';
import '../../bloc/recipe_mixin.dart';

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
          reviewsNotifier.value = null;
        },
      );
      return subscription.cancel;
    }, [recipeID]);

    return Material(
      borderRadius: BorderRadius.circular(5),
      color: ExtraColors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Row(
          children: [
            const Icon(
              Icons.reviews_outlined,
              color: ExtraColors.white,
              size: 17,
            ),
            const SizedBox(width: 1),
            reviewsNotifier.value == null
                ? const LoadingTextView(width: 7, height: 7)
                : Text(
                    reviewsNotifier.value.toString(),
                    style:
                        const TextStyle(color: ExtraColors.white, fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }
}
