// To parse this JSON data, do
//
//     final blockedListModel = blockedListModelFromJson(jsonString);

import 'dart:convert';

BlockedListModel blockedListModelFromJson(String str) => BlockedListModel.fromJson(json.decode(str));

String blockedListModelToJson(BlockedListModel data) => json.encode(data.toJson());

class BlockedListModel {
  BlockedListModel({
    this.status,
    this.message,
    this.blockedArray,
    this.blockedCount,
  });

  String status;
  String message;
  List<BlockedArray> blockedArray;
  int blockedCount;

  factory BlockedListModel.fromJson(Map<String, dynamic> json) => BlockedListModel(
    status: json["status"],
    message: json["message"],
    blockedArray: List<BlockedArray>.from(json["blockedArray"].map((x) => BlockedArray.fromJson(x))),
    blockedCount: json["blocked_count"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "blockedArray": List<dynamic>.from(blockedArray.map((x) => x.toJson())),
    "blocked_count": blockedCount,
  };
}

class BlockedArray {
  BlockedArray({
    this.userId,
    this.name,
    this.image,
  });

  int userId;
  String name;
  String image;

  factory BlockedArray.fromJson(Map<String, dynamic> json) => BlockedArray(
    userId: json["user_id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "image": image,
  };
}
