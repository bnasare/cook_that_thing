// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
      name: json['name'] as String,
      ingredients: json['ingredients'] as String,
      instructions: json['instructions'] as String,
      description: json['description'] as String,
      time: json['time'] as String,
      servings: json['servings'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      chef: json['chef'] as String,
      chefID: json['chefID'] as String,
      id: json['id'] as String,
      likes: (json['likes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'description': instance.description,
      'time': instance.time,
      'servings': instance.servings,
      'category': instance.category,
      'image': instance.image,
      'chef': instance.chef,
      'chefID': instance.chefID,
      'id': instance.id,
      'likes': instance.likes,
    };
