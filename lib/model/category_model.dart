class CategoryModel {
  String? id;
  String? name;
  String? imageUrl;
  String? description;

  CategoryModel({this.id, this.name, this.imageUrl, this.description});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["idCategory"] ?? "",
      name: json["strCategory"] ?? "Unknown Category",
      imageUrl: json["strCategoryThumb"] ?? "",
      description: json["strCategoryDescription"] ?? "",
    );
  }
}
