import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/core/review/presentation/interface/pages/create_review.dart';
import 'package:recipe_hub/shared/widgets/empty_state_view.dart';

import '../../../../../shared/data/image_assets.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../domain/entities/review.dart';
import '../../bloc/review_mixin.dart';
import '../widgets/rating_widget.dart';
import '../widgets/review_card.dart';

class ViewReviewsPage extends HookWidget with ReviewMixin {
  final String recipeID;
  ViewReviewsPage({super.key, required this.recipeID});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      fetchReviewsByRecipeID(context, recipeID);
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: StreamBuilder(
        stream: fetchReviewsByRecipeID(context, recipeID),
        builder: (BuildContext context, AsyncSnapshot<List<Review>> snapshot) {
          List<Review>? reviews = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitFadingCircle(
              color: Theme.of(context).colorScheme.primary,
            );
          }
          if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                children: [
                  Image.asset(ImageAssets.viewed, width: 300, height: 300),
                  const SizedBox(height: 30),
                  Text(
                    'Nothing to show here..',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 21,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ));
          }

          double averageReviews = getAverageReviews(reviews!);

          return reviews.isEmpty
              ? EmptyStateView(
                  title: 'No Reviews',
                  buttonText: 'Write a Review',
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          // ignore: deprecated_member_use
                          return WillPopScope(
                            onWillPop: () async {
                              Navigator.pop(context);
                              return true;
                            },
                            child: CreateReviewPage(recipeID: recipeID),
                          );
                        },
                      ),
                    );
                  },
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        title: Text(
                          '${reviews.length} ${reviews.length == 1 ? 'Review' : 'Reviews'}',
                          style: const TextStyle(
                              color: ExtraColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              '$averageReviews',
                              style: const TextStyle(
                                  color: ExtraColors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18),
                            ),
                            RatingDisplay(rating: averageReviews, itemSize: 18),
                          ],
                        ),
                        trailing: FilledButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.primary),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5)),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    // ignore: deprecated_member_use
                                    return WillPopScope(
                                      onWillPop: () async {
                                        Navigator.pop(context);
                                        return true;
                                      },
                                      child:
                                          CreateReviewPage(recipeID: recipeID),
                                    );
                                  },
                                ),
                              );
                            },
                            icon: const Icon(IconlyLight.edit, size: 17),
                            label: const Text('Add Review',
                                style: TextStyle(fontSize: 17))),
                      ),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: reviews.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 5.0),
                          itemBuilder: (context, index) {
                            return ReviewCard(
                              name: reviews[index].name,
                              rating: reviews[index].rating,
                              time: reviews[index].time,
                              review: reviews[index].review,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  static double getAverageReviews(List<Review> reviews) {
    double sum = 0;
    for (Review review in reviews) {
      double rating = review.rating;
      sum += rating;
    }
    double average = sum / reviews.length;
    return double.parse(average.toStringAsFixed(1));
  }
}
