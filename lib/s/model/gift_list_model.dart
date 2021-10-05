// To parse this JSON data, do
//
//     final giftListModel = giftListModelFromJson(jsonString);

import 'dart:convert';

GiftListModel giftListModelFromJson(String str) => GiftListModel.fromJson(json.decode(str));

String giftListModelToJson(GiftListModel data) => json.encode(data.toJson());

class GiftListModel {
  GiftListModel({
    this.status,
    this.message,
    this.giftData,
  });

  String status;
  String message;
  List<GiftDatum> giftData;

  factory GiftListModel.fromJson(Map<String, dynamic> json) => GiftListModel(
    status: json["status"],
    message: json["message"],
    giftData: List<GiftDatum>.from(json["discoverArr"].map((x) => GiftDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "GiftData": List<dynamic>.from(giftData.map((x) => x.toJson())),
  };
}

class GiftDatum {
  GiftDatum({
    this.id,
    this.name,
    this.image,
    this.coins,
  });

  int id;
  String name;
  int coins;
  String image;

  factory GiftDatum.fromJson(Map<String, dynamic> json) => GiftDatum(
    id: json["id"],
    name: json["name"],
    coins: json["coins"] != null ? json["coins"] : 1,
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}
