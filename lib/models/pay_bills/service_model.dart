// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
    int? serviceId;
    String? serviceName;
    dynamic serviceImgUrl;
    dynamic category;
    dynamic categoryId;

    ServiceModel({
        this.serviceId,
        this.serviceName,
        this.serviceImgUrl,
        this.category,
        this.categoryId,
    });

    factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        serviceId: json["service_id"],
        serviceName: json["service_name"],
        serviceImgUrl: json["service_img_url"],
        category: json["category"],
        categoryId: json["category_id"],
    );

    Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "service_name": serviceName,
        "service_img_url": serviceImgUrl,
        "category": category,
        "category_id": categoryId,
    };
}
