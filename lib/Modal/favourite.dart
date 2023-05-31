// To parse this JSON data, do
//
//     final favouriteList = favouriteListFromJson(jsonString);

import 'dart:convert';

FavouriteList favouriteListFromJson(String str) => FavouriteList.fromJson(json.decode(str));

String favouriteListToJson(FavouriteList data) => json.encode(data.toJson());

class FavouriteList {
  Data? data;

  FavouriteList({
    this.data,
  });

  factory FavouriteList.fromJson(Map<String, dynamic> json) => FavouriteList(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  String? message;
  List<Datum>? data;

  Data({
    this.message,
    this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  String? place;
  String? latitude;
  String? longitude;
  int? userId;
  int? status;
  DateTime? createAt;

  Datum({
    this.id,
    this.name,
    this.place,
    this.latitude,
    this.longitude,
    this.userId,
    this.status,
    this.createAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    place: json["place"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    userId: json["user_id"],
    status: json["status"],
    createAt: DateTime.parse(json["createAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "place": place,
    "latitude": latitude,
    "longitude": longitude,
    "user_id": userId,
    "status": status,
    "createAt": createAt!.toIso8601String(),
  };
}
