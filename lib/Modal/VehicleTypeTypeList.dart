// To parse this JSON data, do
//
//     final vehicleTypeTypeList = vehicleTypeTypeListFromJson(jsonString);

import 'dart:convert';

VehicleTypeTypeList vehicleTypeTypeListFromJson(String str) => VehicleTypeTypeList.fromJson(json.decode(str));

String vehicleTypeTypeListToJson(VehicleTypeTypeList data) => json.encode(data.toJson());

class VehicleTypeTypeList {
  int? status;
  String? message;
  List<VehicleTypeModel>? data;

  VehicleTypeTypeList({
    this.status,
    this.message,
    this.data,
  });

  factory VehicleTypeTypeList.fromJson(Map<String, dynamic> json) => VehicleTypeTypeList(
    status: json["status"],
    message: json["message"],
    data: List<VehicleTypeModel>.from(json["data"].map((x) => VehicleTypeModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class VehicleTypeModel {
  int? id;
  String? type;
  String? name;
  int? travelTypeId;
  int? basekm;
  int? baseRate;
  int? driverBetta;
  int? hourCharge;
  int? airportCharges;
  int? status;
  DateTime? createAt;

  VehicleTypeModel({
    this.id,
    this.type,
    this.name,
    this.travelTypeId,
    this.basekm,
    this.baseRate,
    this.driverBetta,
    this.hourCharge,
    this.status,
    this.airportCharges,
    this.createAt,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => VehicleTypeModel(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    travelTypeId: json["travel_type_id"],
    basekm: json["basekm"],
    baseRate: json["baseRate"],
    driverBetta: json["driverBetta"],
    hourCharge: json["hour_charge"],
    airportCharges: json["baseFare"],
    status: json["status"],
    createAt: DateTime.parse(json["createAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "travel_type_id": travelTypeId,
    "basekm": basekm,
    "baseRate": baseRate,
    "driverBetta": driverBetta,
    "hour_charge": hourCharge,
    "baseFare": airportCharges,
    "status": status,
    "createAt": createAt!.toIso8601String(),
  };
}
