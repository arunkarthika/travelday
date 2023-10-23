// To parse this JSON data, do
//
//     final travelTypeList = travelTypeListFromJson(jsonString);

import 'dart:convert';

TravelTypeList travelTypeListFromJson(String str) => TravelTypeList.fromJson(json.decode(str));

String travelTypeListToJson(TravelTypeList data) => json.encode(data.toJson());

class TravelTypeList {
  int? status;
  String? message;
  List<Datum>? data;

  TravelTypeList({
    this.status,
    this.message,
    this.data,
  });

  factory TravelTypeList.fromJson(Map<String, dynamic> json) => TravelTypeList(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? type;
  String? name;
  int? status;
  DateTime? createAt;

  Datum({
    this.id,
    this.type,
    this.name,
    this.status,
    this.createAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    status: json["status"],
    createAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "status": status,
    "createAt": createAt!.toIso8601String(),
  };
}
