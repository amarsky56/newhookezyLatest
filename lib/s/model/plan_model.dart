// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
  PlanModel({
    this.status,
    this.message,
    this.plans,
  });

  String status;
  String message;
  List<Plan> plans;

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    status: json["status"],
    message: json["message"],
    plans: List<Plan>.from(json["plans"].map((x) => Plan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "plans": List<dynamic>.from(plans.map((x) => x.toJson())),
  };
}

class Plan {
  Plan({
    this.id,
    this.plan,
    this.coins,
    this.beforediscount,
    this.afterdiscount,
    this.discountpercent,
    this.createdAt,
  });

  int id;
  String plan;
  String coins;
  String beforediscount;
  String afterdiscount;
  String discountpercent;
  DateTime createdAt;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["id"],
    plan: json["plan"],
    coins: json["coins"],
    beforediscount: json["beforediscount"],
    afterdiscount: json["afterdiscount"],
    discountpercent: json["discountpercent"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan": plan,
    "coins": coins,
    "beforediscount": beforediscount,
    "afterdiscount": afterdiscount,
    "discountpercent": discountpercent,
    "created_at": createdAt.toIso8601String(),
  };
}
