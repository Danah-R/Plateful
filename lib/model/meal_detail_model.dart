class MealDetailModel {
  String? id;
  String? name;
  String? category;
  String? area;
  String? instructions;
  String? imageUrl;
  String? tags;
  String? youtubeUrl;
  List<String> ingredients;
  List<String> measures;

  MealDetailModel({
    this.id,
    this.name,
    this.category,
    this.area,
    this.instructions,
    this.imageUrl,
    this.tags,
    this.youtubeUrl,
    required this.ingredients,
    required this.measures,
  });

  factory MealDetailModel.fromJson(Map<String, dynamic> json) {
    List<String> ingredientsList = [];
    List<String> measuresList = [];

    for (var i = 1; i <= 20; i++) {
      var ingredient = json["strIngredient$i"];
      var measure = json["strMeasure$i"];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredientsList.add(ingredient);
        measuresList.add(measure ?? "");
      }
    }

    return MealDetailModel(
      id: json["idMeal"] ?? "",
      name: json["strMeal"] ?? "Unknown Meal",
      category: json["strCategory"] ?? "",
      area: json["strArea"] ?? "",
      instructions: json["strInstructions"] ?? "",
      imageUrl: json["strMealThumb"] ?? "",
      tags: json["strTags"] ?? "",
      youtubeUrl: json["strYoutube"] ?? "",
      ingredients: ingredientsList,
      measures: measuresList,
    );
  }
}
