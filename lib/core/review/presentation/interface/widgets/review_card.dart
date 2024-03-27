import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../shared/presentation/theme/extra_colors.dart';
import 'rating_widget.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.name,
    required this.time,
    required this.review,
    required this.rating,
  });

  final String name;
  final DateTime time;
  final String review;
  final double rating;

  @override
  Widget build(BuildContext context) {
    String formattedDate = timeago.format(time,
        locale: Localizations.localeOf(context).toString(), allowFromNow: true);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Icon(
                  CupertinoIcons.person_alt_circle,
                  color: ExtraColors.darkGrey,
                  size: 50,
                ),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      letterSpacing: -0.5,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: ExtraColors.black,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                formattedDate, // Updated to use the relative time string
                style: const TextStyle(
                  letterSpacing: -0.5,
                  color: ExtraColors.darkGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              review,
              style: const TextStyle(
                height: 1.4,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: ExtraColors.darkGrey,
              ),
              maxLines: null,
              softWrap: true,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RatingDisplay(rating: rating, itemSize: 25),
              const SizedBox(width: 5),
              Text('$rating',
                  style: const TextStyle(
                      color: ExtraColors.darkGrey, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }
}
