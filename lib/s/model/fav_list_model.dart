// To parse this JSON data, do
//
//     final favListModel = favListModelFromJson(jsonString);

import 'dart:convert';

FavListModel favListModelFromJson(String str) => FavListModel.fromJson(json.decode(str));

String favListModelToJson(FavListModel data) => json.encode(data.toJson());

class FavListModel {
  FavListModel({
    this.status,
    this.message,
    this.categories,
  });

  String status;
  String message;
  List<Category> categories;

  factory FavListModel.fromJson(Map<String, dynamic> json) => FavListModel(
    status: json["status"],
    message: json["message"],
    categories: List<Category>.from(json["Categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "Categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.id,
    this.name,
    this.image,
  });

  int id;
  String name;
  String image;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}
