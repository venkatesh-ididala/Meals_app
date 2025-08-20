import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_animation/models/meal.dart';


class FavoritesMealsNotifier extends StateNotifier<List<Meal>> {
  FavoritesMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList(); //meal is removed
      return false;
    } else {
      state = [...state, meal]; //meal is added
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoritesMealsNotifier, List<Meal>>((ref) {
  return FavoritesMealsNotifier(); //expose the current state
});
