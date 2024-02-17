// To parse this JSON data, do
//
//     final checkForceUpdate = checkForceUpdateFromJson(jsonString);

import 'dart:convert';

CheckForceUpdate checkForceUpdateFromJson(String str) => CheckForceUpdate.fromJson(json.decode(str));

String checkForceUpdateToJson(CheckForceUpdate data) => json.encode(data.toJson());

class CheckForceUpdate {
  bool? status;
  Data? data;

  CheckForceUpdate({
    this.status,
    this.data,
  });

  factory CheckForceUpdate.fromJson(Map<String, dynamic> json) => CheckForceUpdate(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  bool? update;
  bool? forceUpdate;
  bool? dirtyCache;
  dynamic updateDevice;

  Data({
    this.update,
    this.forceUpdate,
    this.dirtyCache,
    this.updateDevice,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    update: json["update"],
    forceUpdate: json["force_update"],
    dirtyCache: json["dirty_cache"],
    updateDevice: json["update_device"],
  );

  Map<String, dynamic> toJson() => {
    "update": update,
    "force_update": forceUpdate,
    "dirty_cache": dirtyCache,
    "update_device": updateDevice,
  };
}
// use this response if they provide statuscode in response not direct data.
/*
// To parse this JSON data, do
//
//     final checkForceUpdate = checkForceUpdateFromJson(jsonString);

import 'dart:convert';

CheckForceUpdate checkForceUpdateFromJson(String str) => CheckForceUpdate.fromJson(json.decode(str));

String checkForceUpdateToJson(CheckForceUpdate data) => json.encode(data.toJson());

class CheckForceUpdate {
  bool? status;
  int? statuscode;
  String? message;
  CheckForceUpdateData? data;

  CheckForceUpdate({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory CheckForceUpdate.fromJson(Map<String, dynamic> json) => CheckForceUpdate(
    status: json["status"],
    statuscode: json["statuscode"],
    message: json["message"],
    data: json["data"] == null ? null : CheckForceUpdateData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statuscode": statuscode,
    "message": message,
    "data": data?.toJson(),
  };
}

class CheckForceUpdateData {
  bool? status;
  DataData? data;

  CheckForceUpdateData({
    this.status,
    this.data,
  });

  factory CheckForceUpdateData.fromJson(Map<String, dynamic> json) => CheckForceUpdateData(
    status: json["status"],
    data: json["data"] == null ? null : DataData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class DataData {
  bool? update;
  bool? forceUpdate;
  bool? dirtyCache;
  dynamic updateDevice;

  DataData({
    this.update,
    this.forceUpdate,
    this.dirtyCache,
    this.updateDevice,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    update: json["update"],
    forceUpdate: json["force_update"],
    dirtyCache: json["dirty_cache"],
    updateDevice: json["update_device"],
  );

  Map<String, dynamic> toJson() => {
    "update": update,
    "force_update": forceUpdate,
    "dirty_cache": dirtyCache,
    "update_device": updateDevice,
  };
}
*/
