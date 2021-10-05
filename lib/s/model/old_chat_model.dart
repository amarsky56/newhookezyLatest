// To parse this JSON data, do
//
//     final oldChatModel = oldChatModelFromJson(jsonString);

import 'dart:convert';

OldChatModel oldChatModelFromJson(String str) => OldChatModel.fromJson(json.decode(str));

String oldChatModelToJson(OldChatModel data) => json.encode(data.toJson());

class OldChatModel {
  OldChatModel({
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
  List<OldItem> items;

  factory OldChatModel.fromJson(Map<String, dynamic> json) => OldChatModel(
    isSuccess: json["isSuccess"],
    statusCode: json["statusCode"],
    pageNo: json["pageNo"],
    pageSize: json["pageSize"],
    total: json["total"],
    items: List<OldItem>.from(json["items"].map((x) => OldItem.fromJson(x))),
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

class OldItem {
  OldItem({
    this.fromMsg,
    this.toMsg,
    this.msg,
    this.date,
  });

  String fromMsg;

  String toMsg;
  String msg;
  DateTime date;

  factory OldItem.fromJson(Map<String, dynamic> json) => OldItem(
    fromMsg: json["fromMsg"],

    toMsg: json["toMsg"],
    msg: json["msg"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "fromMsg": msgValues.reverse[fromMsg],
    "toMsg": msgValues.reverse[toMsg],
    "msg": msg,
    "date": date.toIso8601String(),
  };
}

enum Msg { SONU, CHETNA }

final msgValues = EnumValues({
  "chetna": Msg.CHETNA,
  "sonu": Msg.SONU
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
