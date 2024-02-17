import 'dart:convert';
// To parse this JSON data, do
//
//     final operatorModel = operatorModelFromJson(jsonString);


OperatorModel operatorModelFromJson(String str) => OperatorModel.fromJson(json.decode(str));

String operatorModelToJson(OperatorModel data) => json.encode(data.toJson());

class OperatorModel {
    int? operatorId;
    String? operatorName;
    String? operatorImgUrl;
    int? serviceId;
    String? country;
    String? isoCode;

    OperatorModel({
        this.operatorId,
        this.operatorName,
        this.operatorImgUrl,
        this.serviceId,
        this.country,
        this.isoCode,
    });

    factory OperatorModel.fromJson(Map<String, dynamic> json) => OperatorModel(
        operatorId: json["operator_id"],
        operatorName: json["operator_name"],
        operatorImgUrl: json["operator_img_url"],
        serviceId: json["service_id"],
        country: json["country"],
        isoCode: json["iso_code"],
    );

    Map<String, dynamic> toJson() => {
        "operator_id": operatorId,
        "operator_name": operatorName,
        "operator_img_url": operatorImgUrl,
        "service_id": serviceId,
        "country": country,
        "iso_code": isoCode,
    };
}
