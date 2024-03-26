import 'package:event_bus/event_bus.dart';

class DatabaseCollections {
  static const recipes = 'recipes';
  static const chefs = 'chefs';
  static const reviews = 'reviews';
  static const favoriteRecipes = 'favoriteRecipes';
}

final eventBus = EventBus();
