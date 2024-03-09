import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String name,
    required String ingredients,
    required String instructions,
    required String description,
    required String time,
    required String servings,
    required String category,
    required String image,
    required String chef,
    required String chefID,
    required String id,
    required List<String> likes,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  factory Recipe.initial() => const Recipe(
        name: '',
        ingredients: '',
        instructions: '',
        description: '',
        time: '',
        servings: '',
        category: '',
        image: '',
        chef: '',
        chefID: '',
        id: '',
        likes: [],
      );
}
