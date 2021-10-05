

class PaymentUpdateModel{


  String plan;
  String coins;
  String beforediscount;
  String afterdiscount;
  String discountpercent;
  String userId;
  String paymentId;
  String paymentType;
  int planId;


  PaymentUpdateModel({
    this.plan,
    this.coins,
    this.userId,
    this.beforediscount,
    this.afterdiscount,
    this.discountpercent,
    this.planId,
    this.paymentId,
    this.paymentType
  });


  Map<String, dynamic> toJson() => {
    // "plan": plan,
    "coins": coins,
    "userId":userId,
    "paymentId":paymentId,
    "paymentType":paymentType
    // "beforediscount": beforediscount,
    // "afterdiscount": afterdiscount,
    // "discountpercent": discountpercent,
    // "planId": planId,

  };




}