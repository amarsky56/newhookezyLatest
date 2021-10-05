// To parse this JSON data, do
//
//     final myEarningModel = myEarningModelFromJson(jsonString);

import 'dart:convert';

MyEarningModel myEarningModelFromJson(String str) => MyEarningModel.fromJson(json.decode(str));

String myEarningModelToJson(MyEarningModel data) => json.encode(data.toJson());

class MyEarningModel {
  MyEarningModel({
    this.status,
    this.message,
    this.name,
    this.email,
    this.deviceId,
    this.coins,
    this.currentCoins,
  });

  String status;
  String message;
  String name;
  dynamic email;
  String deviceId;
  String coins;
  int currentCoins;

  factory MyEarningModel.fromJson(Map<String, dynamic> json) => MyEarningModel(
    status: json["status"],
    message: json["message"],
    name: json["name"],
    email: json["email"],
    deviceId: json["deviceId"],
    coins: json["coins"],
    currentCoins: json["current_coins"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "name": name,
    "email": email,
    "deviceId": deviceId,
    "coins": coins,
    "current_coins": currentCoins,
  };
}
