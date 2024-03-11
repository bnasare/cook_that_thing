import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String title,
    required String overview,
    required String duration,
    required String category,
    required String image,
    required String chef,
    required String chefID,
    required String id,
    required String chefToken,
    required List<String> likes,
    required List<String> ingredients,
    required List<String> instructions,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  factory Recipe.initial() => const Recipe(
        title: '',
        overview: '',
        duration: '',
        category: '',
        image: '',
        chef: '',
        chefID: '',
        id: '',
        chefToken: '',
        likes: [],
        ingredients: [],
        instructions: [],
      );
}
