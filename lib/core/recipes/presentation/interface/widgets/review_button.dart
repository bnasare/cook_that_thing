import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class ReviewButton extends HookWidget {
  // final String recipeID;
  const ReviewButton({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewsNotifier = useState<int?>(null);

    // useEffect(() {
    // final subscription = fetchReviewsByRecipeID(context, recipeID).listen(
    // (reviews) {
    // reviewsNotifier.value = reviews.length;
    // },
    // onError: (error) {
    // reviewsNotifier.value = null;
    // },
    // );
    // return subscription.cancel;
    // }, [recipeID]);

    return Material(
      borderRadius: BorderRadius.circular(5),
      color: ExtraColors.grey,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Row(
          children: [
            Icon(
              Icons.reviews_outlined,
              color: ExtraColors.white,
              size: 17,
            ),
            SizedBox(width: 1),
            // reviewsNotifier.value == null
            // ? const LoadingTextView(width: 7, height: 7)
            Text(
              '1',
              style: TextStyle(color: ExtraColors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
