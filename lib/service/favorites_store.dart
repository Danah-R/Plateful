import 'package:plateful/model/planned_meal.dart';

class FavoritesStore {
  FavoritesStore._();

  static final Map<String, PlannedMeal> _favorites = {};

  static List<PlannedMeal> get favorites => _favorites.values.toList();

  static bool isFavorite(String mealId) => _favorites.containsKey(mealId);

  static void toggleFavorite(PlannedMeal meal) {
    if (_favorites.containsKey(meal.id)) {
      _favorites.remove(meal.id);
    } else {
      _favorites[meal.id] = meal;
    }
  }
}
