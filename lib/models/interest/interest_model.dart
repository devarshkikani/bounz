import 'dart:convert';
// To parse this JSON data, do
//
//     final interest = interestFromJson(jsonString);

Interest interestFromJson(String str) => Interest.fromJson(json.decode(str));

String interestToJson(Interest data) => json.encode(data.toJson());

class Interest {
  int? id;
  String? name;
  String? image;
  String? unselectedImage;
  String? imageNew;
  int? sequence;

  Interest({
    this.id,
    this.name,
    this.image,
    this.unselectedImage,
    this.imageNew,
    this.sequence,
  });

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        unselectedImage: json["unselected_image"],
        imageNew: json["image_new"],
        sequence: json["sequence"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "unselected_image": unselectedImage,
        "image_new": imageNew,
        "sequence": sequence,
      };
}
