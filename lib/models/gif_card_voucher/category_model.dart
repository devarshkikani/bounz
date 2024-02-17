import 'dart:convert';
// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

CategoryModel categoryFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String? categoryName;
  String? categoryCode;
  int? categoryId;
  String? categoryIcon;
  String? sequence;
  int? count;

  CategoryModel({
    this.categoryName,
    this.categoryCode,
    this.categoryId,
    this.categoryIcon,
    this.sequence,
    this.count,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryName: json["category_name"],
        categoryCode: json["category_code"],
        categoryId: json["category_id"],
        categoryIcon: json["category_icon"],
        sequence: json["sequence"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "category_name": categoryName,
        "category_code": categoryCode,
        "category_id": categoryId,
        "category_icon": categoryIcon,
        "sequence": sequence,
        "count": count,
      };
}
