// To parse this JSON data, do
//
//     final recentChatModel = recentChatModelFromJson(jsonString);

import 'dart:convert';

RecentChatModel recentChatModelFromJson(String str) => RecentChatModel.fromJson(json.decode(str));

String recentChatModelToJson(RecentChatModel data) => json.encode(data.toJson());

class RecentChatModel {
  RecentChatModel({
    this.isSuccess,
    this.statusCode,
    this.pageNo,
    this.pageSize,
    this.total,
    this.items,
  });

  bool isSuccess;
  int statusCode;
  int pageNo;
  int pageSize;
  int total;
  List<Item> items;

  factory RecentChatModel.fromJson(Map<String, dynamic> json) => RecentChatModel(
    isSuccess: json["isSuccess"],
    statusCode: json["statusCode"],
    pageNo: json["pageNo"],
    pageSize: json["pageSize"],
    total: json["total"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "statusCode": statusCode,
    "pageNo": pageNo,
    "pageSize": pageSize,
    "total": total,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  Item({
    this.roomId,
    this.sender,
    this.reciever,
    this.lastSeen,
    this.image,
    this.nameTwo,
    this.nameOne,
    this.userId
  });

  String roomId;
  String sender;
  String reciever;
  String image;
  int userId;
  DateTime lastSeen;
  String nameOne;
  String nameTwo;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    roomId: json["room_id"],
    sender: json["sender"],
    userId: json["userId"] != "null" ? int.parse(json["userId"]) : 1,
    image:json["image"].toString().length > 0 ? json["image"] : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLUU4RH0MQoXrtxXHncCFi3H6S9saN_i49lQ&usqp=CAU",
    reciever: json["reciever"],
    nameOne: json["sender"],
    nameTwo: json["reciever"],
    //lastSeen: DateTime.parse(json["lastSeen"]),
  );

  Map<String, dynamic> toJson() => {
    "room_id": roomId,
    "sender": sender,
    "reciever": reciever,
    "lastSeen": lastSeen.toIso8601String(),
  };
}
