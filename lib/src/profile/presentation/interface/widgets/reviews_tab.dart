import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/review/domain/entities/review.dart';
import '../../../../../core/review/presentation/interface/widgets/review_card.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/presentation/widgets/error_view.dart';

class ReviewTab extends HookWidget with ChefMixin {
  final String chefID;
  final Stream<List<Review>>? stream;

  ReviewTab(this.stream, {super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Review>>(
      stream: stream,
      builder: (context, snapshot) {
        List<Review>? reviews = snapshot.data;
        if (snapshot.hasError) {
          return const ErrorViewWidget();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const ErrorViewWidget();
        } else if (snapshot.hasData) {
          return ListView.separated(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
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
      },
    );
  }
}
