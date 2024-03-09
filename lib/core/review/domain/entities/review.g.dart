// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      name: json['name'] as String,
      review: json['review'] as String,
      time: DateTime.parse(json['time'] as String),
      recipeID: json['recipeID'] as String,
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'review': instance.review,
      'time': instance.time.toIso8601String(),
      'recipeID': instance.recipeID,
      'rating': instance.rating,
    };
