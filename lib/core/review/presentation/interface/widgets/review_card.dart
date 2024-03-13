import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final color = Theme.of(context).colorScheme;
    String formattedDate = DateFormat('dd MMM, yyyy').format(time);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Icon(
                      CupertinoIcons.person_alt_circle_fill,
                      color: ExtraColors.darkGrey,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          name,
                          style: const TextStyle(
                            letterSpacing: -0.5,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ExtraColors.black,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.calendar_today,
                            size: 13,
                            color: ExtraColors.grey,
                          ),
                          Text(
                            ' $formattedDate',
                            style: const TextStyle(
                              letterSpacing: -0.5,
                              color: ExtraColors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          softWrap: true,
                          text: TextSpan(children: [
                            TextSpan(
                              text: '$rating',
                              style: const TextStyle(
                                color: ExtraColors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(
                              text: ' ratings',
                              style: TextStyle(
                                color: ExtraColors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                              ),
                            ),
                          ]),
                        ),
                        Row(
                          children: [
                            RatingDisplay(rating: rating),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: FittedBox(
                child: Text(
                  review,
                  style: const TextStyle(
                    height: 1.4,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: ExtraColors.black,
                  ),
                  maxLines: null,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
