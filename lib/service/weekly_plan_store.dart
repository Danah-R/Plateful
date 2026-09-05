import 'package:plateful/model/planned_meal.dart';

class WeeklyPlanStore {
  WeeklyPlanStore._();

  static const List<String> days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];

  static const List<String> mealTypes = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Dessert / Snack",
  ];

  static final Map<String, Map<String, PlannedMeal?>> _plan = {
    for (final day in days) day: {for (final type in mealTypes) type: null},
  };

  static Map<String, PlannedMeal?> mealsForDay(String day) => _plan[day]!;

  static void assignMeal(String day, String mealType, PlannedMeal meal) {
    _plan[day]![mealType] = meal;
  }

  static bool isMealPlanned(String mealId) {
    return _plan.values.any(
      (meals) => meals.values.any((meal) => meal?.id == mealId),
    );
  }
}
