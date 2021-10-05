// To parse this JSON data, do
//
//     final audioCallSearchingUserApi = audioCallSearchingUserApiFromJson(jsonString);

import 'dart:convert';

AudioCallSearchingUserApi audioCallSearchingUserApiFromJson(String str) => AudioCallSearchingUserApi.fromJson(json.decode(str));

String audioCallSearchingUserApiToJson(AudioCallSearchingUserApi data) => json.encode(data.toJson());

class AudioCallSearchingUserApi {
  AudioCallSearchingUserApi({
    this.isSuccess,
    this.statusCode,
    this.data,
  });

  bool isSuccess;
  int statusCode;
  List<dynamic> data;

  factory AudioCallSearchingUserApi.fromJson(Map<String, dynamic> json) => AudioCallSearchingUserApi(
    isSuccess: json["isSuccess"],
    statusCode: json["statusCode"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "statusCode": statusCode,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
