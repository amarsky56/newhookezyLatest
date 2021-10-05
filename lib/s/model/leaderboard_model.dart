// // To parse this JSON data, do
// //
// //     final leaderBoardModel = leaderBoardModelFromJson(jsonString);
//
// import 'dart:convert';
//
// LeaderBoardModel leaderBoardModelFromJson(String str) => LeaderBoardModel.fromJson(json.decode(str));
//
// String leaderBoardModelToJson(LeaderBoardModel data) => json.encode(data.toJson());
//
// class LeaderBoardModel {
//   LeaderBoardModel({
//     this.status,
//     this.message,
//     this.categories,
//   });
//
//   String status;
//   String message;
//   List<Category> categories;
//
//   factory LeaderBoardModel.fromJson(Map<String, dynamic> json) => LeaderBoardModel(
//     status: json["status"],
//     message: json["message"],
//     categories: List<Category>.from(json["Categories"].map((x) => Category.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "Categories": List<dynamic>.from(categories.map((x) => x.toJson())),
//   };
// }
//
// class Category {
//   Category({
//     this.id,
//     this.name,
//     this.email,
//     this.coins,
//     this.status,
//     this.phoneNo,
//     this.role,
//     this.image,
//     this.country
//   });
//
//   int id;
//   String name;
//   String email;
//   String coins;
//   String status;
//   dynamic phoneNo;
//   Role role;
//   String image;
//   String country;
//
//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//     id: json["id"],
//     name: json["name"],
//     email: json["email"] == null ? null : json["email"],
//     coins: json["coins"],
//     status: json["status"],
//     phoneNo: json["phone_no"],
//     country:json["country"] != null ? json["country"] : "India",
//     role: roleValues.map[json["role"]],
//     image: json["image"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "email": email == null ? null : email,
//     "coins": coins,
//     "status": status,
//     "phone_no": phoneNo,
//     "role": roleValues.reverse[role],
//     "image": image,
//   };
// }
//
// enum Role { USER, HOST }
//
// final roleValues = EnumValues({
//   "Host": Role.HOST,
//   "User": Role.USER
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }

// To parse this JSON data, do
//
//     final leaderBoardModel = leaderBoardModelFromJson(jsonString);

import 'dart:convert';

LeaderBoardModel leaderBoardModelFromJson(String str) => LeaderBoardModel.fromJson(json.decode(str));

String leaderBoardModelToJson(LeaderBoardModel data) => json.encode(data.toJson());

class LeaderBoardModel {
  LeaderBoardModel({
    this.status,
    this.message,
    this.leaderboardArr,
    this.myrankArr,
  });

  String status;
  String message;
  List<Arr> leaderboardArr;
  List<Arr> myrankArr;

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) => LeaderBoardModel(
    status: json["status"],
    message: json["message"],
    leaderboardArr: List<Arr>.from(json["leaderboardArr"].map((x) => Arr.fromJson(x))),
    myrankArr: List<Arr>.from(json["myrankArr"].map((x) => Arr.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "leaderboardArr": List<dynamic>.from(leaderboardArr.map((x) => x.toJson())),
    "myrankArr": List<dynamic>.from(myrankArr.map((x) => x.toJson())),
  };
}

class Arr {
  Arr({
    this.rank,
    this.id,
    this.name,
    this.country,
    this.coins,
    this.image,
    this.obfuscateName
  });

  int rank;
  int id;
  String name;
  String country;
  String coins;
  String image;
  String obfuscateName;

  factory Arr.fromJson(Map<String, dynamic> json) => Arr(
    rank: json["rank"],
    id: json["id"],
    name: json["name"],
    obfuscateName: "${json["name"].toString().substring(0,1).toUpperCase()}****",
    country: json["country"] == null ? "Country not defined" : json["country"],
    coins: json["coins"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "rank": rank,
    "id": id,
    "name": name,
    "country": country == null ? null : country,
    "coins": coins,
    "image": image,
  };
}
