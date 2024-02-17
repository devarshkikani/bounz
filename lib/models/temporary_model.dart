import 'dart:convert';
// To parse this JSON data, do
//
//     final myBounz = myBounzFromJson(jsonString);

MyBounz myBounzFromJson(String str) =>
    MyBounz.fromJson(json.decode(str) as Map<String, dynamic>);

String myBounzToJson(MyBounz data) => json.encode(data.toJson());

class MyBounz {
  MyBounz({
    required this.isExpanded,
  });
  factory MyBounz.fromJson(Map<String, dynamic> json) => MyBounz(
        isExpanded: json['isExpanded'] as bool,
      );

  bool isExpanded = false;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isExpanded': isExpanded,
      };
}
