// To parse this JSON data, do
//
//     final discoverListModel = discoverListModelFromJson(jsonString);

import 'dart:convert';

DiscoverListModel discoverListModelFromJson(String str) => DiscoverListModel.fromJson(json.decode(str));

String discoverListModelToJson(DiscoverListModel data) => json.encode(data.toJson());

class DiscoverListModel {
  DiscoverListModel({
    this.status,
    this.message,
    this.languageArr,
    this.discoverArr,
  });

  String status;
  String message;
  List<LanguageArr> languageArr;
  List<DiscoverArr> discoverArr;

  factory DiscoverListModel.fromJson(Map<String, dynamic> json) => DiscoverListModel(
    status: json["status"],
    message: json["message"],
    languageArr: List<LanguageArr>.from(json["languageArr"].map((x) => LanguageArr.fromJson(x))),
    discoverArr: List<DiscoverArr>.from(json["discoverArr"].map((x) => DiscoverArr.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "discoverArr": List<dynamic>.from(discoverArr.map((x) => x.toJson())),
  };
}

class DiscoverArr {
  DiscoverArr({
    this.id,
    this.name,
    this.email,
    this.coins,
    this.status,
    this.phoneNo,
    this.role,
    this.image
  });

  int id;
  String name;
  dynamic email;
  String coins;
  String status;
  dynamic phoneNo;
  String role;
  String image;

  factory DiscoverArr.fromJson(Map<String, dynamic> json) => DiscoverArr(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    coins: json["coins"],
    status: json["status"],
    phoneNo: json["phone_no"],
    role: json["role"],
    image: json["image"].toString().length != 0 ? json["image"] : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLUU4RH0MQoXrtxXHncCFi3H6S9saN_i49lQ&usqp=CAU"
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "coins": coins,
    "status": status,
    "phone_no": phoneNo,
    "role": role,
  };
}


class LanguageArr {
  LanguageArr({
    this.language,
  });

  String language;

  factory LanguageArr.fromJson(Map<String, dynamic> json) => LanguageArr(
    language: json["language"],
  );

  Map<String, dynamic> toJson() => {
    "language": language,
  };
}
