class MealModel {
  String? id;
  String? name;
  String? imageUrl;

  MealModel({this.id, this.name, this.imageUrl});

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json["idMeal"] ?? "",
      name: json["strMeal"] ?? "Unknown Meal",
      imageUrl: json["strMealThumb"] ?? "",
    );
  }
}
