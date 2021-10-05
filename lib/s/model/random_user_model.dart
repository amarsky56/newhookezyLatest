// To parse this JSON data, do
//
//     final randomUserModel = randomUserModelFromJson(jsonString);

import 'dart:convert';

import 'package:hookezy/s/utils/app.dart';

RandomUserModel randomUserModelFromJson(String str) => RandomUserModel.fromJson(json.decode(str));

String randomUserModelToJson(RandomUserModel data) => json.encode(data.toJson());

class RandomUserModel {
  RandomUserModel({
    this.status,
    this.message,
    this.id,
    this.deviceId,
    this.name,
    this.quid,
    this.uuid,
  });

  String status;
  String message;
  int id;
  String deviceId;
  String name;
  int quid;
  int uuid;

  factory RandomUserModel.fromJson(Map<String, dynamic> json) => RandomUserModel(
    status: json["status"],
    message: json["message"],
    id: json["id"],
    uuid: json["uuid"] != null  ? int.parse(json["uuid"]) : null,
    //uuid: int.parse(json["uuid"]),
    quid: AppConstant.QUICKBLOX_GUEST_ID,
    deviceId: json["device_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "id": id,
    "device_id": deviceId,
    "name": name,
  };
}
