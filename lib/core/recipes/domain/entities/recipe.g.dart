// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
      diet: json['diet'] as String,
      difficultyLevel: json['difficultyLevel'] as String,
      title: json['title'] as String,
      overview: json['overview'] as String,
      duration: json['duration'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      chef: json['chef'] as String,
      chefID: json['chefID'] as String,
      id: json['id'] as String,
      chefToken: json['chefToken'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: (json['likes'] as List<dynamic>).map((e) => e as String).toList(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'diet': instance.diet,
      'difficultyLevel': instance.difficultyLevel,
      'title': instance.title,
      'overview': instance.overview,
      'duration': instance.duration,
      'category': instance.category,
      'image': instance.image,
      'chef': instance.chef,
      'chefID': instance.chefID,
      'id': instance.id,
      'chefToken': instance.chefToken,
      'createdAt': instance.createdAt.toIso8601String(),
      'likes': instance.likes,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
    };
