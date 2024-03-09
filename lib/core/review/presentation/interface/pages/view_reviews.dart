import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/core/review/presentation/interface/pages/create_review.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../domain/entities/review.dart';
import '../widgets/rating_widget.dart';
import '../widgets/review_card.dart';

class ViewReviewsPage extends HookConsumerWidget {
  final String recipeID;
  const ViewReviewsPage({super.key, required this.recipeID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reviews'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                title: const Text(
                  '1 Review',
                  style: TextStyle(
                      color: ExtraColors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: const Row(
                  children: [
                    Text(
                      '4',
                      style: TextStyle(
                          color: ExtraColors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                    RatingDisplay(rating: 5),
                  ],
                ),
                trailing: FilledButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5)),
                    ),
                    onPressed: () {
                      NavigationHelper.navigateTo(
                          context, CreateReviewPage(recipeID: recipeID));
                    },
                    icon: const Icon(IconlyLight.edit, size: 15),
                    label: const Text('Add Review',
                        style: TextStyle(fontSize: 12))),
              ),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 5.0),
                  itemBuilder: (context, index) {
                    return ReviewCard(
                      name: 'Benedict',
                      rating: 4,
                      time: DateTime.now(),
                      review: 'Great recipe',
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  static double getAverageReviews(List<Review> reviews) {
    double sum = 0;
    for (Review review in reviews) {
      double rating = review.rating;
      sum += rating;
    }
    double average = sum / reviews.length;
    return double.parse(average.toStringAsFixed(2));
  }
}
