import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';

class RatingDisplay extends StatelessWidget {
  const RatingDisplay({super.key, required this.rating, this.itemSize = 13});

  final double rating;
  final double itemSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RatingBar.builder(
        initialRating: rating,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: itemSize,
        itemPadding: EdgeInsets.zero,
        itemBuilder: (context, _) => const Icon(
          Icons.grade,
          color: ExtraColors.yellow,
        ),
        onRatingUpdate: (rating) {},
      ),
    );
  }
}
