// To parse this JSON data, do
//
//     final getUserProfileModel = getUserProfileModelFromJson(jsonString);

import 'dart:convert';

import 'dart:io';

import 'package:hookezy/s/utils/app.dart';

GetUserProfileModel getUserProfileModelFromJson(String str) => GetUserProfileModel.fromJson(json.decode(str));

String getUserProfileModelToJson(GetUserProfileModel data) => json.encode(data.toJson());

class GetUserProfileModel {
  GetUserProfileModel({
    this.status,
    this.message,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.deviceId,
    this.role,
    this.details,
    this.coins,
    this.coinss
  });

  String status;
  String message;
  String name;
  String email;
  String coins;
  int coinss;
  String phone;
  String gender;
  dynamic deviceId;
  String role;
  Details details;

  factory GetUserProfileModel.fromJson(Map<String, dynamic> json) => GetUserProfileModel(
    status: json["status"],
    message: json["message"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    gender: json["gender"],
    coins: json["coins"],
    coinss : int.parse(json["coins"]),
    deviceId: json["deviceId"],
    role: json["role"],
    details: Details.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "name": name,
    "email": email,
    "phone": phone,
    "gender": gender,
    "deviceId": deviceId,
    "role": role,
    "details": details.toJson(),
  };
}

class Details {
  Details({
    this.id,
    this.userId,
    this.about,
    this.age,
    this.jobtitle,
    this.company,
    this.education,
    this.uniqueId,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.country,
    this.country_index,
    this.language,
    this.defaultLanguage
  });

  int id;
  int userId;
  dynamic about;
  int country_index;
  dynamic age;
  dynamic jobtitle;
  dynamic company;
  dynamic education;
  String uniqueId;
  String country;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String language;
  String defaultLanguage;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    id: json["id"],
    userId: json["user_id"],
    country: json["country"] != null ? json["country"] : "",
    country_index: json["country_index"],
    language:json["language"],
    defaultLanguage: json["language"] != null  ? json["language"] : AppConstant.DEFAULT_DISCOVER_LANGUAGE,
    about: json["about"] != null ? json["about"] : "",
    age: json["age"],
    jobtitle: json["jobtitle"],
    company: json["company"],
    education: json["education"],
    uniqueId: json["uniqueID"].toString().length == 0 ? "as45Q65xvcb56980ghvbgf" : json["uniqueID"],
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
    "company": company,
    "education": education,
    "uniqueID": uniqueId,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}


class UpdateUserProfileModel {

  UpdateUserProfileModel({
    this.id,
    this.userId,
    this.about,
    this.age,
    this.jobtitle,
    this.company,
    this.education,
    this.uniqueId,
    this.image,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.country_index,
    this.language
  });

  int id;
  int userId;
  String about;
  String country;
  String age;
  String jobtitle;
  String company;
  String education;
  String uniqueId;
  int country_index;
  String language;
  DateTime createdAt;
  DateTime updatedAt;
  String deletedAt;
  File image;

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "about": about,
    "age": age,
    "jobtitle": jobtitle,
    "company": company,
    "language":language,
    "country_index":country_index,
    "country":country,
    "education": education,
    "id": uniqueId,
    "image": image,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
    // "deleted_at": deletedAt,
  };

}