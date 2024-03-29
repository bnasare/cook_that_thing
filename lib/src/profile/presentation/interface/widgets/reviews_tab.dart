import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/review/domain/entities/review.dart';
import '../../../../../core/review/presentation/interface/widgets/review_card.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';

class ReviewTab extends HookWidget with ChefMixin {
  final String chefID;

  ReviewTab({super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    final reviewStream =
        useMemoized(() => fetchReviewsByChefID(context, chefID));

    return ListView(
      padding: const EdgeInsets.only(top: 0),
      shrinkWrap: true,
      children: [
        StreamBuilder<List<Review>>(
            stream: reviewStream,
            builder: (context, snapshot) {
              List<Review>? reviews = snapshot.data;
              if (snapshot.hasError) {
                return const ErrorViewWidget();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
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
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const ErrorViewWidget();
              } else if (snapshot.hasData) {
                return ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: reviews!.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: ExtraColors.lightGrey, thickness: 2),
                  itemBuilder: (context, index) {
                    return ReviewCard(
                      name: reviews[index].name,
                      rating: reviews[index].rating,
                      time: reviews[index].time,
                      review: reviews[index].review,
                    );
                  },
                );
              } else {
                return const ErrorViewWidget();
              }
            }),
      ],
    );
  }
}
