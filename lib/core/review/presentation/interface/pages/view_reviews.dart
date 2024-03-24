import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
                      const SizedBox(height: 5),
                      Text(
                        '$averageReviews',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontWeight: FontWeight.w100),
                      ),
                      const SizedBox(height: 3),
                      RatingDisplay(rating: averageReviews, itemSize: 40),
                      const SizedBox(height: 10),
                      Text(
                        '(${reviews.length} ${reviews.length == 1 ? 'Review' : 'Reviews'})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: ExtraColors.darkGrey),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:
                            Divider(color: ExtraColors.lightGrey, thickness: 2),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.vertical,
                          itemCount: reviews.length,
                          separatorBuilder: (context, index) => const Divider(
                              color: ExtraColors.lightGrey, thickness: 2),
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
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
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
                            child: const Text(
                              'Write a Review',
                              style: TextStyle(fontSize: 18),
                            )),
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
