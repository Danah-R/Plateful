import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:plateful/model/area_model.dart';
import 'package:plateful/model/category_model.dart';
import 'package:plateful/model/meal_detail_model.dart';
import 'package:plateful/model/meal_model.dart';

class Api {
  String categoriesLink =
      "https://www.themealdb.com/api/json/v1/1/categories.php";
  String areasLink = "https://www.themealdb.com/api/json/v1/1/list.php?a=list";
  String mealsByCategoryLink =
      "https://www.themealdb.com/api/json/v1/1/filter.php?c=";
  String mealsByAreaLink =
      "https://www.themealdb.com/api/json/v1/1/filter.php?a=";
  String mealDetailsLink =
      "https://www.themealdb.com/api/json/v1/1/lookup.php?i=";

  Future<List<CategoryModel>> getCategories() async {
    var uri = Uri.parse(categoriesLink);

    var response = await http.get(uri);
    var body = response.body;
    var bodyResponse = jsonDecode(body);

    List<CategoryModel> listData = [];

    for (var item in bodyResponse["categories"]) {
      CategoryModel model = CategoryModel.fromJson(item);
      listData.add(model);
    }
    return listData;
  }

  Future<List<AreaModel>> getAreas() async {
    var uri = Uri.parse(areasLink);

    var response = await http.get(uri);
    var body = response.body;
    var bodyResponse = jsonDecode(body);

    List<AreaModel> listData = [];

    for (var item in bodyResponse["meals"]) {
      AreaModel model = AreaModel.fromJson(item);
      listData.add(model);
    }
    return listData;
  }

  Future<List<MealModel>> getMealsByCategory(String category) async {
    var uri = Uri.parse("$mealsByCategoryLink$category");

    var response = await http.get(uri);
    var body = response.body;
    var bodyResponse = jsonDecode(body);

    List<MealModel> listData = [];

    for (var item in bodyResponse["meals"]) {
      MealModel model = MealModel.fromJson(item);
      listData.add(model);
    }
    return listData;
  }

  Future<List<MealModel>> getMealsByArea(String area) async {
    var uri = Uri.parse("$mealsByAreaLink$area");

    var response = await http.get(uri);
    var body = response.body;
    var bodyResponse = jsonDecode(body);

    List<MealModel> listData = [];

    for (var item in bodyResponse["meals"]) {
      MealModel model = MealModel.fromJson(item);
      listData.add(model);
    }
    return listData;
  }

  Future<List<MealDetailModel>> getAllMeals() async {
    final categories = await getCategories().catchError(
      (_) => <CategoryModel>[],
    );
    final areas = await getAreas().catchError((_) => <AreaModel>[]);

    final mealsByCategoryResults = await Future.wait(
      categories.map(
        (category) =>
            getMealsByCategory(category.name ?? "")
                .catchError((_) => <MealModel>[]),
      ),
    );
    final mealsByAreaResults = await Future.wait(
      areas.map(
        (area) =>
            getMealsByArea(area.name ?? "").catchError((_) => <MealModel>[]),
      ),
    );

    final categoryById = <String, String>{};
    for (var i = 0; i < categories.length; i++) {
      for (final meal in mealsByCategoryResults[i]) {
        if (meal.id != null) categoryById[meal.id!] = categories[i].name ?? "";
      }
    }

    final areaById = <String, String>{};
    for (var i = 0; i < areas.length; i++) {
      for (final meal in mealsByAreaResults[i]) {
        if (meal.id != null) areaById[meal.id!] = areas[i].name ?? "";
      }
    }

    final mealById = <String, MealModel>{};
    for (final list in [...mealsByCategoryResults, ...mealsByAreaResults]) {
      for (final meal in list) {
        if (meal.id != null) mealById[meal.id!] = meal;
      }
    }

    return mealById.values.map((meal) {
      return MealDetailModel(
        id: meal.id,
        name: meal.name,
        imageUrl: meal.imageUrl,
        category: categoryById[meal.id] ?? "",
        area: areaById[meal.id] ?? "",
        instructions: "",
        tags: "",
        youtubeUrl: "",
        ingredients: [],
        measures: [],
      );
    }).toList();
  }

  Future<List<MealDetailModel>> getMealsForFilters({
    required List<String> areas,
    required List<String> categories,
  }) async {
    if (areas.isEmpty && categories.isEmpty) {
      return getAllMeals();
    }

    final mealsByArea = <String, MealDetailModel>{};
    if (areas.isNotEmpty) {
      final results = await Future.wait(
        areas.map(
          (area) => getMealsByArea(area).catchError((_) => <MealModel>[]),
        ),
      );
      for (var i = 0; i < areas.length; i++) {
        for (final meal in results[i]) {
          if (meal.id == null) continue;
          mealsByArea[meal.id!] = MealDetailModel(
            id: meal.id,
            name: meal.name,
            imageUrl: meal.imageUrl,
            area: areas[i],
            category: "",
            instructions: "",
            tags: "",
            youtubeUrl: "",
            ingredients: [],
            measures: [],
          );
        }
      }
    }

    final mealsByCategory = <String, MealDetailModel>{};
    if (categories.isNotEmpty) {
      final results = await Future.wait(
        categories.map(
          (category) =>
              getMealsByCategory(category).catchError((_) => <MealModel>[]),
        ),
      );
      for (var i = 0; i < categories.length; i++) {
        for (final meal in results[i]) {
          if (meal.id == null) continue;
          mealsByCategory[meal.id!] = MealDetailModel(
            id: meal.id,
            name: meal.name,
            imageUrl: meal.imageUrl,
            area: "",
            category: categories[i],
            instructions: "",
            tags: "",
            youtubeUrl: "",
            ingredients: [],
            measures: [],
          );
        }
      }
    }

    if (areas.isNotEmpty && categories.isNotEmpty) {
      final matchingIds = mealsByArea.keys.toSet().intersection(
        mealsByCategory.keys.toSet(),
      );
      return matchingIds.map((id) {
        final areaInfo = mealsByArea[id]!;
        final categoryInfo = mealsByCategory[id]!;
        return MealDetailModel(
          id: id,
          name: areaInfo.name,
          imageUrl: areaInfo.imageUrl,
          area: areaInfo.area,
          category: categoryInfo.category,
          instructions: "",
          tags: "",
          youtubeUrl: "",
          ingredients: [],
          measures: [],
        );
      }).toList();
    }

    return areas.isNotEmpty
        ? mealsByArea.values.toList()
        : mealsByCategory.values.toList();
  }

  Future<MealDetailModel> getMealDetails(String id) async {
    var uri = Uri.parse("$mealDetailsLink$id");

    var response = await http.get(uri);
    var body = response.body;
    var bodyResponse = jsonDecode(body);

    var meal = bodyResponse["meals"][0];
    return MealDetailModel.fromJson(meal);
  }
}
