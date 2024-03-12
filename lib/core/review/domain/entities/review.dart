import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String name,
    required String review,
    required DateTime time,
    required String recipeID,
    required double rating,
    required String chefToken,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  factory Review.initial() => Review(
        name: '',
        review: '',
        time: DateTime.now(),
        recipeID: '',
        rating: 0.0,
        chefToken: '',
      );
}
