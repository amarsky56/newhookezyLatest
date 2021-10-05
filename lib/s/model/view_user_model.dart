// To parse this JSON data, do
//
//     final viewUserModel = viewUserModelFromJson(jsonString);

import 'dart:convert';

ViewUserModel viewUserModelFromJson(String str) => ViewUserModel.fromJson(json.decode(str));

String viewUserModelToJson(ViewUserModel data) => json.encode(data.toJson());

class ViewUserModel {
  ViewUserModel({
    this.status,
    this.message,
    this.isFav,
    this.isBlock,
    this.coins,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.deviceId,
    this.role,
    this.uuid,
    this.viewDetails,
  });

  String status;
  String message;
  String isFav;
  String isBlock;
  String coins;
  String name;
  String email;
  dynamic phone;
  int uuid;
  String gender;
  String deviceId;
  String role;
  ViewDetails viewDetails;

  factory ViewUserModel.fromJson(Map<String, dynamic> json) => ViewUserModel(
    status: json["status"],
    message: json["message"],
    isFav: json["isFav"],
    isBlock: json["isBlock"],
    coins: json["coins"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    gender: json["gender"],
    deviceId: json["deviceId"],
    uuid: json["uuid"] != null  ? int.parse(json["uuid"]) : null,
    role: json["role"],
    viewDetails: ViewDetails.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "isFav": isFav,
    "isBlock": isBlock,
    "coins": coins,
    "name": name,
    "email": email,
    "phone": phone,
    "gender": gender,
    "deviceId": deviceId,
    "role": role,
    "ViewDetails": viewDetails.toJson(),
  };
}

class ViewDetails {
  ViewDetails({
    this.id,
    this.userId,
    this.about,
    this.age,
    this.jobtitle,
    this.countryIndex,
    this.country,
    this.language,
    this.company,
    this.education,
    this.uniqueId,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  int userId;
  dynamic about;
  dynamic age;
  dynamic jobtitle;
  dynamic countryIndex;
  dynamic country;
  dynamic language;
  dynamic company;
  dynamic education;
  dynamic uniqueId;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory ViewDetails.fromJson(Map<String, dynamic> json) => ViewDetails(
    id: json["id"],
    userId: json["user_id"],
    about: json["about"],
    age: json["age"],
    jobtitle: json["jobtitle"],
    countryIndex: json["country_index"],
    country: json["country"],
    language: json["language"],
    company: json["company"],
    education: json["education"],
    uniqueId: json["uniqueID"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "about": about,
    "age": age,
    "jobtitle": jobtitle,
    "country_index": countryIndex,
    "country": country,
    "language": language,
    "company": company,
    "education": education,
    "uniqueID": uniqueId,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
