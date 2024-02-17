import 'dart:convert';
// To parse this JSON data, do
//
//     final dashBoardModel = dashBoardModelFromJson(jsonString);

DashBoardModel dashBoardModelFromJson(String str) =>
    DashBoardModel.fromJson(json.decode(str));

String dashBoardModelToJson(DashBoardModel data) => json.encode(data.toJson());

class DashBoardModel {
  bool? status;
  String? statusCode;
  Data? data;

  DashBoardModel({
    this.status,
    this.statusCode,
    this.data,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) => DashBoardModel(
        status: json["status"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "data": data?.toJson(),
      };
}

class Data {
  String? assetPath;
  String? versionCode;
  List<Footer>? header;
  List<Body>? body;
  List<Footer>? footer;
  List<Footer>? theme;
  String? cacheDate;

  Data({
    this.assetPath,
    this.versionCode,
    this.header,
    this.body,
    this.footer,
    this.theme,
    this.cacheDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        assetPath: json["asset_path"],
        versionCode: json["version_code"],
        header: json["header"] == null
            ? []
            : List<Footer>.from(json["header"]!.map((x) => Footer.fromJson(x))),
        body: json["body"] == null
            ? []
            : List<Body>.from(json["body"]!.map((x) => Body.fromJson(x))),
        footer: json["footer"] == null
            ? []
            : List<Footer>.from(json["footer"]!.map((x) => Footer.fromJson(x))),
        theme: json["theme"] == null
            ? []
            : List<Footer>.from(json["theme"]!.map((x) => Footer.fromJson(x))),
        cacheDate: json["cache_date"] == null ? null : (json["cache_date"]),
      );

  Map<String, dynamic> toJson() => {
        "asset_path": assetPath,
        "version_code": versionCode,
        "header": header == null
            ? []
            : List<dynamic>.from(header!.map((x) => x.toJson())),
        "body": body == null
            ? []
            : List<dynamic>.from(body!.map((x) => x.toJson())),
        "footer": footer == null
            ? []
            : List<dynamic>.from(footer!.map((x) => x.toJson())),
        "theme": theme == null
            ? []
            : List<dynamic>.from(theme!.map((x) => x.toJson())),
        "cache_date": cacheDate,
      };
}

class Body {
  String? id;
  String? sectionCode;
  Code? code;
  ProjectCode? projectCode;
  bool? allowTabs;
  bool? status;
  String? sectionTitle;
  bool? showTitle;
  int? rank;
  dynamic sectionData;
  String? componentType;
  ExtraData? extraData;

  Body({
    this.id,
    this.sectionCode,
    this.code,
    this.projectCode,
    this.allowTabs,
    this.status,
    this.sectionTitle,
    this.showTitle,
    this.rank,
    this.sectionData,
    this.componentType,
    this.extraData,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        id: json["_id"],
        sectionCode: json["section_code"],
        code: codeValues.map[json["code"]]!,
        projectCode: projectCodeValues.map[json["project_code"]]!,
        allowTabs: json["allow_tabs"],
        status: json["status"],
        sectionTitle: json["section_title"],
        showTitle: json["show_title"],
        rank: json["rank"],
        sectionData: json["section_data"],
        componentType: json["component_type"],
        extraData: json["extra_data"] == null
            ? null
            : ExtraData.fromJson(json["extra_data"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "section_code": sectionCode,
        "code": codeValues.reverse[code],
        "project_code": projectCodeValues.reverse[projectCode],
        "allow_tabs": allowTabs,
        "status": status,
        "section_title": sectionTitle,
        "show_title": showTitle,
        "rank": rank,
        "section_data": sectionData,
        "component_type": componentType,
        "extra_data": extraData?.toJson(),
      };
}

enum Code { homepage }

final codeValues = EnumValues({"homepage": Code.homepage});

class ExtraData {
  String? imagesPerView;
  String? moreTabs;
  String? moreTabsRedirect;
  String? viewAll;
  String? backgroundColor;
  String? fontColor;
  String? gridColumns;
  String? readMore;
  String? show;

  ExtraData({
    this.imagesPerView,
    this.moreTabs,
    this.moreTabsRedirect,
    this.viewAll,
    this.backgroundColor,
    this.fontColor,
    this.gridColumns,
    this.readMore,
    this.show,
  });

  factory ExtraData.fromJson(Map<String, dynamic> json) => ExtraData(
        imagesPerView: json["images_per_view"],
        moreTabs: json["more_tabs"],
        moreTabsRedirect: json["more_tabs_redirect"],
        viewAll: json["view_all"],
        backgroundColor: json["background_color"],
        fontColor: json["font_color"],
        gridColumns: json["grid_columns"],
        readMore: json["read_more"],
        show: json["show"],
      );

  Map<String, dynamic> toJson() => {
        "images_per_view": imagesPerView,
        "more_tabs": moreTabs,
        "more_tabs_redirect": moreTabsRedirect,
        "view_all": viewAll,
        "background_color": backgroundColor,
        "font_color": fontColor,
        "grid_columns": gridColumns,
        "read_more": readMore,
        "show": show,
      };
}

enum ProjectCode { codestack, bounzMobile }

final projectCodeValues = EnumValues({
  "codestack": ProjectCode.codestack,
  "bounz_mobile": ProjectCode.bounzMobile
});

class SectionDatum {
  String? code;
  String? heading;
  List<SectionDatumDatum>? data;
  ComponentType? componentType;

  SectionDatum({
    this.code,
    this.heading,
    this.data,
    this.componentType,
  });

  factory SectionDatum.fromJson(Map<String, dynamic> json) => SectionDatum(
        code: json["code"],
        heading: json["heading"],
        data: json["data"] == null
            ? []
            : List<SectionDatumDatum>.from(
                json["data"]!.map((x) => SectionDatumDatum.fromJson(x))),
        componentType: componentTypeValues.map[json["component_type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "heading": heading,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "component_type": componentTypeValues.reverse[componentType],
      };
}

enum ComponentType { slider, grid, banner }

final componentTypeValues = EnumValues({
  "banner": ComponentType.banner,
  "grid": ComponentType.grid,
  "slider": ComponentType.slider
});

class SectionDatumDatum {
  Type? type;
  String? imgUrl;
  String? imgDesc;
  NavigationType? navigationType;
  String? navigationLink;
  String? iconUrl;
  String? iconLabel;

  SectionDatumDatum({
    this.type,
    this.imgUrl,
    this.imgDesc,
    this.navigationType,
    this.navigationLink,
    this.iconUrl,
    this.iconLabel,
  });

  factory SectionDatumDatum.fromJson(Map<String, dynamic> json) =>
      SectionDatumDatum(
        type: typeValues.map[json["type"]]!,
        imgUrl: json["img_url"],
        imgDesc: json["img_desc"],
        navigationType: navigationTypeValues.map[json["navigation_type"]]!,
        navigationLink: json["navigation_link"],
        iconUrl: json["icon_url"],
        iconLabel: json["icon_label"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "img_url": imgUrl,
        "img_desc": imgDesc,
        "navigation_type": navigationTypeValues.reverse[navigationType],
        "navigation_link": navigationLink,
        "icon_url": iconUrl,
        "icon_label": iconLabel,
      };
}

enum NavigationType { internal, external, intenral }

final navigationTypeValues = EnumValues({
  "external": NavigationType.external,
  "intenral": NavigationType.intenral,
  "internal": NavigationType.internal
});

enum Type { image, icon }

final typeValues = EnumValues({"icon": Type.icon, "image": Type.image});

class SectionDataClass {
  String? code;
  String? heading;
  List<SectionDataDatum>? data;

  SectionDataClass({
    this.code,
    this.heading,
    this.data,
  });

  factory SectionDataClass.fromJson(Map<String, dynamic> json) =>
      SectionDataClass(
        code: json["code"],
        heading: json["heading"],
        data: json["data"] == null
            ? []
            : List<SectionDataDatum>.from(
                json["data"]!.map((x) => SectionDataDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "heading": heading,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SectionDataDatum {
  String? type;
  String? vdoType;
  String? vdoUrl;
  String? vdoDesc;
  String? title;
  String? description;
  DateTime? endTime;

  SectionDataDatum({
    this.type,
    this.vdoType,
    this.vdoUrl,
    this.vdoDesc,
    this.title,
    this.description,
    this.endTime,
  });

  factory SectionDataDatum.fromJson(Map<String, dynamic> json) =>
      SectionDataDatum(
        type: json["type"],
        vdoType: json["vdo_type"],
        vdoUrl: json["vdo_url"],
        vdoDesc: json["vdo_desc"],
        title: json["title"],
        description: json["description"],
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "vdo_type": vdoType,
        "vdo_url": vdoUrl,
        "vdo_desc": vdoDesc,
        "title": title,
        "description": description,
        "end_time": endTime?.toIso8601String(),
      };
}

class Footer {
  String? id;
  String? type;
  String? appSettingName;
  String? appSettingCode;
  ProjectCode? projectCode;
  bool? isDefault;
  bool? status;
  List<FooterDatum>? data;
  dynamic createdAt;
  int? createdBy;
  List<Tab>? tabs;

  Footer({
    this.id,
    this.type,
    this.appSettingName,
    this.appSettingCode,
    this.projectCode,
    this.isDefault,
    this.status,
    this.data,
    this.createdAt,
    this.createdBy,
    this.tabs,
  });

  factory Footer.fromJson(Map<String, dynamic> json) => Footer(
        id: json["_id"],
        type: json["type"],
        appSettingName: json["app_setting_name"],
        appSettingCode: json["app_setting_code"],
        projectCode: projectCodeValues.map[json["project_code"]]!,
        isDefault: json["is_default"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<FooterDatum>.from(
                json["data"]!.map((x) => FooterDatum.fromJson(x))),
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        tabs: json["tabs"] == null
            ? []
            : List<Tab>.from(json["tabs"]!.map((x) => Tab.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "app_setting_name": appSettingName,
        "app_setting_code": appSettingCode,
        "project_code": projectCodeValues.reverse[projectCode],
        "is_default": isDefault,
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "created_at": createdAt,
        "created_by": createdBy,
        "tabs": tabs == null
            ? []
            : List<dynamic>.from(tabs!.map((x) => x.toJson())),
      };
}

class FooterDatum {
  ValueType? valueType;
  String? key;
  String? value;

  FooterDatum({
    this.valueType,
    this.key,
    this.value,
  });

  factory FooterDatum.fromJson(Map<String, dynamic> json) => FooterDatum(
        valueType: valueTypeValues.map[json["value_type"]]!,
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value_type": valueTypeValues.reverse[valueType],
        "key": key,
        "value": value,
      };
}

enum ValueType { text, select, assetSelect }

final valueTypeValues = EnumValues({
  "asset_select": ValueType.assetSelect,
  "select": ValueType.select,
  "text": ValueType.text
});

class Tab {
  Type? type;
  String? iconUrl;
  String? iconLabel;
  NavigationType? navigationType;
  String? navigationLink;

  Tab({
    this.type,
    this.iconUrl,
    this.iconLabel,
    this.navigationType,
    this.navigationLink,
  });

  factory Tab.fromJson(Map<String, dynamic> json) => Tab(
        type: typeValues.map[json["type"]]!,
        iconUrl: json["icon_url"],
        iconLabel: capitalizeFirstLetter(json["icon_label"]),
        navigationType: navigationTypeValues.map[json["navigation_type"]]!,
        navigationLink: json["navigation_link"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "icon_url": iconUrl,
        "icon_label": iconLabel,
        "navigation_type": navigationTypeValues.reverse[navigationType],
        "navigation_link": navigationLink,
      };
  static String? capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class SectionData {
  String? code;
  String? heading;
  List<Datum>? data;
  String? componentType;

  SectionData({
    this.code,
    this.heading,
    this.data,
    this.componentType,
  });

  factory SectionData.fromJson(Map<String, dynamic> json) => SectionData(
        code: json["code"],
        heading: json["heading"],
        componentType: json["component_type"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "heading": heading,
        "component_type": componentType,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? type;
  String? imgUrl;
  String? imgDesc;
  String? navigationType;
  String? navigationLink;

  Datum({
    this.type,
    this.imgUrl,
    this.imgDesc,
    this.navigationType,
    this.navigationLink,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: json["type"],
        imgUrl: json["img_url"],
        imgDesc: json["img_desc"],
        navigationType: json["navigation_type"],
        navigationLink: json["navigation_link"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "img_url": imgUrl,
        "img_desc": imgDesc,
        "navigation_type": navigationType,
        "navigation_link": navigationLink,
      };
}

class SectionSubData {
  String? type;
  String? vdoType;
  String? vdoUrl;
  String? vdoDesc;

  SectionSubData({
    this.type,
    this.vdoType,
    this.vdoUrl,
    this.vdoDesc,
  });

  factory SectionSubData.fromJson(Map<String, dynamic> json) => SectionSubData(
        type: json["type"],
        vdoType: json["vdo_type"],
        vdoUrl: json["vdo_url"],
        vdoDesc: json["vdo_desc"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "vdo_type": vdoType,
        "vdo_url": vdoUrl,
        "vdo_desc": vdoDesc,
      };
}

class SectionIconData {
  String? type;
  String? iconUrl;
  String? iconLabel;
  String? navigationType;
  String? navigationLink;

  SectionIconData({
    this.type,
    this.iconUrl,
    this.iconLabel,
    this.navigationType,
    this.navigationLink,
  });

  factory SectionIconData.fromJson(Map<String, dynamic> json) =>
      SectionIconData(
        type: json["type"],
        iconUrl: json["icon_url"],
        iconLabel: json["icon_label"],
        navigationType: json["navigation_type"],
        navigationLink: json["navigation_link"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "icon_url": iconUrl,
        "icon_label": iconLabel,
        "navigation_type": navigationType,
        "navigation_link": navigationLink,
      };
}

FeaturedOfferSectionData featuredOfferSectionDataFromJson(String str) =>
    FeaturedOfferSectionData.fromJson(json.decode(str));

String featuredOfferSectionDataToJson(FeaturedOfferSectionData data) =>
    json.encode(data.toJson());

class FeaturedOfferSectionData {
  String? code;
  String? heading;
  List<Datum>? data;
  String? componentType;

  FeaturedOfferSectionData({
    this.code,
    this.heading,
    this.data,
    this.componentType,
  });

  factory FeaturedOfferSectionData.fromJson(Map<String, dynamic> json) =>
      FeaturedOfferSectionData(
        code: json["code"],
        heading: json["heading"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        componentType: json["component_type"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "heading": heading,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "component_type": componentType,
      };
}
