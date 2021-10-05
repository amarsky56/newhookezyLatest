// To parse this JSON data, do
//
//     final uploadProfilePictuerApi = uploadProfilePictuerApiFromJson(jsonString);

import 'dart:convert';

UploadProfilePictuerApi uploadProfilePictuerApiFromJson(String str) => UploadProfilePictuerApi.fromJson(json.decode(str));

String uploadProfilePictuerApiToJson(UploadProfilePictuerApi data) => json.encode(data.toJson());

class UploadProfilePictuerApi {
  UploadProfilePictuerApi({
    this.isSuccess,
    this.statusCode,
    this.data,
    this.message,
  });

  bool isSuccess;
  int statusCode;
  Data data;
  String message;

  factory UploadProfilePictuerApi.fromJson(Map<String, dynamic> json) => UploadProfilePictuerApi(
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
    this.abouMe,
    this.age,
    this.jobTitle,
    this.company,
    this.education,
    this.id,
    this.lastLoggedIn,
    this.dataId,
    this.deviceToken,
    this.createdOn,
    this.updatedOn,
    this.v,
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
  String abouMe;
  String age;
  String jobTitle;
  String company;
  String education;
  String id;
  dynamic lastLoggedIn;
  String dataId;
  String deviceToken;
  DateTime createdOn;
  DateTime updatedOn;
  int v;

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
    abouMe: json["abouMe"],
    age: json["age"],
    jobTitle: json["jobTitle"],
    company: json["company"],
    education: json["education"],
    id: json["ID"],
    lastLoggedIn: json["lastLoggedIn"],
    dataId: json["_id"],
    deviceToken: json["deviceToken"],
    createdOn: DateTime.parse(json["createdOn"]),
    updatedOn: DateTime.parse(json["updatedOn"]),
    v: json["__v"],
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
    "abouMe": abouMe,
    "age": age,
    "jobTitle": jobTitle,
    "company": company,
    "education": education,
    "ID": id,
    "lastLoggedIn": lastLoggedIn,
    "_id": dataId,
    "deviceToken": deviceToken,
    "createdOn": createdOn.toIso8601String(),
    "updatedOn": updatedOn.toIso8601String(),
    "__v": v,
  };
}
