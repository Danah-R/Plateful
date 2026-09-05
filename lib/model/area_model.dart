class AreaModel {
  String? name;

  AreaModel({this.name});

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(name: json["strArea"] ?? "Unknown Area");
  }
}
