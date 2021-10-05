// To parse this JSON data, do
//
//     final updateprofileInfoApi = updateprofileInfoApiFromJson(jsonString);

import 'dart:convert';

UpdateprofileInfoApi updateprofileInfoApiFromJson(String str) => UpdateprofileInfoApi.fromJson(json.decode(str));

String updateprofileInfoApiToJson(UpdateprofileInfoApi data) => json.encode(data.toJson());

class UpdateprofileInfoApi {
  UpdateprofileInfoApi({
    this.isSuccess,
    this.statusCode,
    this.data,
  });

  bool isSuccess;
  int statusCode;
  Data data;

  factory UpdateprofileInfoApi.fromJson(Map<String, dynamic> json) => UpdateprofileInfoApi(
    isSuccess: json["isSuccess"],
    statusCode: json["statusCode"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "statusCode": statusCode,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.userName,
    this.phoneNumber,
    this.email,
    this.status,
    this.sex,
    this.deviceToken,
    this.updatedOn,
    this.createdOn,
  });

  String id;
  String userName;
  String phoneNumber;
  String email;
  String status;
  String sex;
  String deviceToken;
  DateTime updatedOn;
  DateTime createdOn;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    userName: json["userName"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    status: json["status"],
    sex: json["sex"],
    deviceToken: json["deviceToken"],
    updatedOn: DateTime.parse(json["updatedOn"]),
    createdOn: DateTime.parse(json["createdOn"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "phoneNumber": phoneNumber,
    "email": email,
    "status": status,
    "sex": sex,
    "deviceToken": deviceToken,
    "updatedOn": updatedOn.toIso8601String(),
    "createdOn": createdOn.toIso8601String(),
  };
}
