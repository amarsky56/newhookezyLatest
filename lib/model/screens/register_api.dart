// To parse this JSON data, do
//
//     final registerApi = registerApiFromJson(jsonString);

import 'dart:convert';

RegisterApi registerApiFromJson(String str) => RegisterApi.fromJson(json.decode(str));

String registerApiToJson(RegisterApi data) => json.encode(data.toJson());

class RegisterApi {
  RegisterApi({
    this.isSuccess,
    this.statusCode,
    this.data,
    this.message,
  });

  bool isSuccess;
  int statusCode;
  Data data;
  String message;

  factory RegisterApi.fromJson(Map<String, dynamic> json) => RegisterApi(
    isSuccess: json["isSuccess"],
    statusCode: json["statusCode"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "statusCode": statusCode,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.userId,
    this.userName,
    this.name,
    this.email,
    this.phoneNumber,
    this.profilePic,
    this.type,
    this.status,
    this.coins,
    this.avatar,
    this.sex,
    this.lastLoggedIn,
    this.id,
    this.deviceToken,
    this.createdOn,
    this.updatedOn,
  });

  String userId;
  String userName;
  String name;
  String email;
  String phoneNumber;
  String profilePic;
  String type;
  String status;
  int coins;
  String avatar;
  String sex;
  dynamic lastLoggedIn;
  String id;
  String deviceToken;
  DateTime createdOn;
  DateTime updatedOn;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["userId"],
    userName: json["userName"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    profilePic: json["profilePic"],
    type: json["type"],
    status: json["status"],
    coins: json["coins"],
    avatar: json["avatar"],
    sex: json["sex"],
    lastLoggedIn: json["lastLoggedIn"],
    id: json["_id"],
    deviceToken: json["deviceToken"],
    createdOn: DateTime.parse(json["createdOn"]),
    updatedOn: DateTime.parse(json["updatedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
    "profilePic": profilePic,
    "type": type,
    "status": status,
    "coins": coins,
    "avatar": avatar,
    "sex": sex,
    "lastLoggedIn": lastLoggedIn,
    "_id": id,
    "deviceToken": deviceToken,
    "createdOn": createdOn.toIso8601String(),
    "updatedOn": updatedOn.toIso8601String(),
  };
}
