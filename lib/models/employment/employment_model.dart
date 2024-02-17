import 'dart:convert';
// To parse this JSON data, do
//
//     final employmentModel = employmentModelFromJson(jsonString);

EmploymentModel employmentModelFromJson(String str) =>
    EmploymentModel.fromJson(json.decode(str));

String employmentModelToJson(EmploymentModel data) =>
    json.encode(data.toJson());

class EmploymentModel {
  int? id;
  String? code;
  String? name;
  dynamic description;

  EmploymentModel({
    this.id,
    this.code,
    this.name,
    this.description,
  });

  factory EmploymentModel.fromJson(Map<String, dynamic> json) =>
      EmploymentModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
      };
}
