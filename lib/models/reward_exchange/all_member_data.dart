// To parse this JSON data, do
//
//     final allMemberModel = allMemberModelFromJson(jsonString);

import 'dart:convert';

AllMemberModel allMemberModelFromJson(String str) => AllMemberModel.fromJson(json.decode(str));

String allMemberModelToJson(AllMemberModel data) => json.encode(data.toJson());

class AllMemberModel {
  bool? status;
  int? statuscode;
  String? message;
  DataAllMember? data;

  AllMemberModel({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory AllMemberModel.fromJson(Map<String, dynamic> json) => AllMemberModel(
    status: json["status"],
    statuscode: json["statuscode"],
    message: json["message"],
    data: json["data"] == null ? null : DataAllMember.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statuscode": statuscode,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataAllMember {
  String? messageStatus;
  String? errorDescription;
  int? errorCode;
  DateTime? timestamp;
  List<OtherPartner>? otherPartners;
  List<LinkedPartner>? linkedPartners;
  String? cipherMessageId;

  DataAllMember({
    this.messageStatus,
    this.errorDescription,
    this.errorCode,
    this.timestamp,
    this.otherPartners,
    this.linkedPartners,
    this.cipherMessageId,
  });

  factory DataAllMember.fromJson(Map<String, dynamic> json) => DataAllMember(
    messageStatus: json["messageStatus"],
    errorDescription: json["errorDescription"],
    errorCode: json["errorCode"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    otherPartners: json["otherPartners"] == null ? [] : List<OtherPartner>.from(json["otherPartners"]!.map((x) => OtherPartner.fromJson(x))),
    linkedPartners: json["linkedPartners"] == null ? [] : List<LinkedPartner>.from(json["linkedPartners"]!.map((x) => LinkedPartner.fromJson(x))),
    cipherMessageId: json["cipherMessageId"],
  );

  Map<String, dynamic> toJson() => {
    "messageStatus": messageStatus,
    "errorDescription": errorDescription,
    "errorCode": errorCode,
    "timestamp": timestamp?.toIso8601String(),
    "otherPartners": otherPartners == null ? [] : List<dynamic>.from(otherPartners!.map((x) => x.toJson())),
    "linkedPartners": linkedPartners == null ? [] : List<dynamic>.from(linkedPartners!.map((x) => x)),
    "cipherMessageId": cipherMessageId,
  };
}

class OtherPartner {
  String? sourceLoyaltyProgramCode;
  String? targetLoyaltyProgramCode;
  String? targetLoyaltyProgramCodeAr;
  String? targetOrgCode;
  String? logo;
  String? pointUpdateType;
  int? tokenPeriodValidityInMins;
  int? tokenPeriodGraceTimeInMins;
  String? linkingParam;
  String? termsAndConditions;
  String? termsAndConditionsAr;
  Os? so;
  Os? os;
  String? key;
  String? sourceLoyaltyProgramCodeAr;
  String? programCodeLabelAr;
  String? programCodeLabelEn;
  String? availableOn;
  DateTime? startDate;
  DateTime? endDate;
  String? feeType;
  String? feeTypeAr;
  int? feeValue;
  int? otpLength;
  String? logoRef;
  String? unitType;
  String? unitTypeAr;
  String? preferredChannel;
  String? preferredChannelAr;
  String? validationRegEx;

  OtherPartner({
    this.sourceLoyaltyProgramCode,
    this.targetLoyaltyProgramCode,
    this.targetLoyaltyProgramCodeAr,
    this.targetOrgCode,
    this.logo,
    this.pointUpdateType,
    this.tokenPeriodValidityInMins,
    this.tokenPeriodGraceTimeInMins,
    this.linkingParam,
    this.termsAndConditions,
    this.termsAndConditionsAr,
    this.so,
    this.os,
    this.key,
    this.sourceLoyaltyProgramCodeAr,
    this.programCodeLabelAr,
    this.programCodeLabelEn,
    this.availableOn,
    this.startDate,
    this.endDate,
    this.feeType,
    this.feeTypeAr,
    this.feeValue,
    this.otpLength,
    this.logoRef,
    this.unitType,
    this.unitTypeAr,
    this.preferredChannel,
    this.preferredChannelAr,
    this.validationRegEx,
  });

  factory OtherPartner.fromJson(Map<String, dynamic> json) => OtherPartner(
    sourceLoyaltyProgramCode: json["sourceLoyaltyProgramCode"],
    targetLoyaltyProgramCode: json["targetLoyaltyProgramCode"],
    targetLoyaltyProgramCodeAr: json["targetLoyaltyProgramCode_AR"],
    targetOrgCode: json["targetOrgCode"],
    logo: json["logo"],
    pointUpdateType: json["pointUpdateType"],
    tokenPeriodValidityInMins: json["tokenPeriodValidityInMins"],
    tokenPeriodGraceTimeInMins: json["tokenPeriodGraceTimeInMins"],
    linkingParam: json["linkingParam"],
    termsAndConditions: json["termsAndConditions"],
    termsAndConditionsAr: json["termsAndConditions_AR"],
    so: json["SO"] == null ? null : Os.fromJson(json["SO"]),
    os: json["OS"] == null ? null : Os.fromJson(json["OS"]),
    key: json["key"],
    sourceLoyaltyProgramCodeAr: json["sourceLoyaltyProgramCode_AR"],
    programCodeLabelAr: json["programCodeLabel_AR"],
    programCodeLabelEn: json["programCodeLabel_EN"],
    availableOn: json["availableOn"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    feeType: json["feeType"],
    feeTypeAr: json["feeType_AR"],
    feeValue: json["feeValue"],
    otpLength: json["OTPLength"],
    logoRef: json["logoRef"],
    unitType: json["unitType"],
    unitTypeAr: json["unitType_AR"],
    preferredChannel: json["preferredChannel"],
    preferredChannelAr: json["preferredChannel_AR"],
    validationRegEx: json["validationRegEx"],
  );

  Map<String, dynamic> toJson() => {
    "sourceLoyaltyProgramCode": sourceLoyaltyProgramCode,
    "targetLoyaltyProgramCode": targetLoyaltyProgramCode,
    "targetLoyaltyProgramCode_AR": targetLoyaltyProgramCodeAr,
    "targetOrgCode": targetOrgCode,
    "logo": logo,
    "pointUpdateType": pointUpdateType,
    "tokenPeriodValidityInMins": tokenPeriodValidityInMins,
    "tokenPeriodGraceTimeInMins": tokenPeriodGraceTimeInMins,
    "linkingParam": linkingParam,
    "termsAndConditions": termsAndConditions,
    "termsAndConditions_AR": termsAndConditionsAr,
    "SO": so?.toJson(),
    "OS": os?.toJson(),
    "key": key,
    "sourceLoyaltyProgramCode_AR": sourceLoyaltyProgramCodeAr,
    "programCodeLabel_AR": programCodeLabelAr,
    "programCodeLabel_EN": programCodeLabelEn,
    "availableOn": availableOn,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "feeType": feeType,
    "feeType_AR": feeTypeAr,
    "feeValue": feeValue,
    "OTPLength": otpLength,
    "logoRef": logoRef,
    "unitType": unitType,
    "unitType_AR": unitTypeAr,
    "preferredChannel": preferredChannel,
    "preferredChannel_AR": preferredChannelAr,
    "validationRegEx": validationRegEx,
  };
}

class LinkedPartner {
  String? sourceLoyaltyProgramCode;
  String? targetLoyaltyProgramCode;
  String? targetLoyaltyProgramCodeAr;
  String? targetOrgCode;
  String? logo;
  String? pointUpdateType;
  int? tokenPeriodValidityInMins;
  int? tokenPeriodGraceTimeInMins;
  String? linkingParam;
  String? termsAndConditions;
  String? termsAndConditionsAr;
  Os? so;
  Os? os;
  String? key;
  String? sourceLoyaltyProgramCodeAr;
  String? programCodeLabelAr;
  String? programCodeLabelEn;
  String? availableOn;
  DateTime? startDate;
  DateTime? endDate;
  String? feeType;
  String? feeTypeAr;
  int? feeValue;
  int? otpLength;
  String? logoRef;
  String? unitType;
  String? unitTypeAr;
  String? preferredChannel;
  String? preferredChannelAr;
  String? validationRegEx;
  String? targetMembershipNo;
  int? points;
  String? status;
  DateTime? nowValue;
  String? isTokenValid;
  DateTime? tokenValidTill;

  LinkedPartner({
    this.sourceLoyaltyProgramCode,
    this.targetLoyaltyProgramCode,
    this.targetLoyaltyProgramCodeAr,
    this.targetOrgCode,
    this.logo,
    this.pointUpdateType,
    this.tokenPeriodValidityInMins,
    this.tokenPeriodGraceTimeInMins,
    this.linkingParam,
    this.termsAndConditions,
    this.termsAndConditionsAr,
    this.so,
    this.os,
    this.key,
    this.sourceLoyaltyProgramCodeAr,
    this.programCodeLabelAr,
    this.programCodeLabelEn,
    this.availableOn,
    this.startDate,
    this.endDate,
    this.feeType,
    this.feeTypeAr,
    this.feeValue,
    this.otpLength,
    this.logoRef,
    this.unitType,
    this.unitTypeAr,
    this.preferredChannel,
    this.preferredChannelAr,
    this.validationRegEx,
    this.targetMembershipNo,
    this.points,
    this.status,
    this.nowValue,
    this.isTokenValid,
    this.tokenValidTill,
  });

  factory LinkedPartner.fromJson(Map<String, dynamic> json) => LinkedPartner(
    sourceLoyaltyProgramCode: json["sourceLoyaltyProgramCode"],
    targetLoyaltyProgramCode: json["targetLoyaltyProgramCode"],
    targetLoyaltyProgramCodeAr: json["targetLoyaltyProgramCode_AR"],
    targetOrgCode: json["targetOrgCode"],
    logo: json["logo"],
    pointUpdateType: json["pointUpdateType"],
    tokenPeriodValidityInMins: json["tokenPeriodValidityInMins"],
    tokenPeriodGraceTimeInMins: json["tokenPeriodGraceTimeInMins"],
    linkingParam: json["linkingParam"],
    termsAndConditions: json["termsAndConditions"],
    termsAndConditionsAr: json["termsAndConditions_AR"],
    so: json["SO"] == null ? null : Os.fromJson(json["SO"]),
    os: json["OS"] == null ? null : Os.fromJson(json["OS"]),
    key: json["key"],
    sourceLoyaltyProgramCodeAr: json["sourceLoyaltyProgramCode_AR"],
    programCodeLabelAr: json["programCodeLabel_AR"],
    programCodeLabelEn: json["programCodeLabel_EN"],
    availableOn: json["availableOn"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    feeType: json["feeType"],
    feeTypeAr: json["feeType_AR"],
    feeValue: json["feeValue"],
    otpLength: json["OTPLength"],
    logoRef: json["logoRef"],
    unitType: json["unitType"],
    unitTypeAr: json["unitType_AR"],
    preferredChannel: json["preferredChannel"],
    preferredChannelAr: json["preferredChannel_AR"],
    validationRegEx: json["validationRegEx"],
    targetMembershipNo: json["targetMembershipNo"],
    points: json["points"],
    status: json["status"],
    nowValue: json["nowValue"] == null ? null : DateTime.parse(json["nowValue"]),
    isTokenValid: json["isTokenValid"],
    tokenValidTill: json["tokenValidTill"] == null ? null : DateTime.parse(json["tokenValidTill"]),
  );

  Map<String, dynamic> toJson() => {
    "sourceLoyaltyProgramCode": sourceLoyaltyProgramCode,
    "targetLoyaltyProgramCode": targetLoyaltyProgramCode,
    "targetLoyaltyProgramCode_AR": targetLoyaltyProgramCodeAr,
    "targetOrgCode": targetOrgCode,
    "logo": logo,
    "pointUpdateType": pointUpdateType,
    "tokenPeriodValidityInMins": tokenPeriodValidityInMins,
    "tokenPeriodGraceTimeInMins": tokenPeriodGraceTimeInMins,
    "linkingParam": linkingParam,
    "termsAndConditions": termsAndConditions,
    "termsAndConditions_AR": termsAndConditionsAr,
    "SO": so?.toJson(),
    "OS": os?.toJson(),
    "key": key,
    "sourceLoyaltyProgramCode_AR": sourceLoyaltyProgramCodeAr,
    "programCodeLabel_AR": programCodeLabelAr,
    "programCodeLabel_EN": programCodeLabelEn,
    "availableOn": availableOn,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "feeType": feeType,
    "feeType_AR": feeTypeAr,
    "feeValue": feeValue,
    "OTPLength": otpLength,
    "logoRef": logoRef,
    "unitType": unitType,
    "unitType_AR": unitTypeAr,
    "preferredChannel": preferredChannel,
    "preferredChannel_AR": preferredChannelAr,
    "validationRegEx": validationRegEx,
    "targetMembershipNo": targetMembershipNo,
    "points": points,
    "status": status,
    "nowValue": nowValue?.toIso8601String(),
    "isTokenValid": isTokenValid,
    "tokenValidTill": tokenValidTill?.toIso8601String(),
  };
}

class Os {
  int? minConversion;
  double? conversionRate;
  int? multipleOf;
  String? roundOffMethod;
  String? isActive;
  int? denominator;
  int? nominator;

  Os({
    this.minConversion,
    this.conversionRate,
    this.multipleOf,
    this.roundOffMethod,
    this.isActive,
    this.denominator,
    this.nominator,
  });

  factory Os.fromJson(Map<String, dynamic> json) => Os(
    minConversion: json["minConversion"],
    conversionRate: json["conversionRate"]?.toDouble(),
    multipleOf: json["multipleOf"],
    roundOffMethod: json["roundOffMethod"],
    isActive: json["isActive"],
    denominator: json["denominator"],
    nominator: json["nominator"],
  );

  Map<String, dynamic> toJson() => {
    "minConversion": minConversion,
    "conversionRate": conversionRate,
    "multipleOf": multipleOf,
    "roundOffMethod": roundOffMethod,
    "isActive": isActive,
    "denominator": denominator,
    "nominator": nominator,
  };
}
