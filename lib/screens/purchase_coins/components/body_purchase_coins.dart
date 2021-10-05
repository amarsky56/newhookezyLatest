import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_pay/flutter_google_pay.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/model/payment_update_model.dart';
import 'package:hookezy/s/model/plan_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/screens/final_step/final_step_screen.dart';
import 'package:hookezy/screens/purchase_coins/CardPayTest.dart';
import 'package:hookezy/screens/purchase_coins/components/background_purchase_coins.dart';
import 'package:hookezy/screens/settings/screen_settings.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class PurchaseCoinsBody extends StatefulWidget {
  GetUserProfileModel getUserProfileModel;

  PurchaseCoinsBody({this.getUserProfileModel});

  @override
  _PurchaseCoinsBodyState createState() => _PurchaseCoinsBodyState();
}

class _PurchaseCoinsBodyState extends State<PurchaseCoinsBody> {
  Token _paymentToken;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
    name: 'Test User',
    cvc: '133',
    addressLine1: 'Address 1',
    addressLine2: 'Address 2',
    addressCity: 'City',
    addressState: 'CA',
    addressZip: '1337',
  );

  PlanModel planModel;
  bool isLoading = true;
  bool isError = false;
  int selectedIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    planPayload();
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  void planPayload() {
    ApiRepository.getPlanModel()
        .then((value) => {
              setState(() {
                planModel = value;
                isLoading = false;
                isError = false;
              })
            })
        .catchError((error) {
      setState(() {
        planModel = null;
        isLoading = false;
        isError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          title: Text("MY COINS"),
          backgroundColor: Color(0xfff576a4),
          centerTitle: true,
        ),
        body: uiPayload());
  }

  Widget uiPayload() {
    if (isError == true) {
      return ErrorScreen(
        onRefresh: () {
          setState(() {
            isLoading = true;
            isError = false;
          });
          planPayload();
        },
      );
    } else {
      return isLoading == true
          ? ProgressLoader(
              title: "Fetching Plans...",
            )
          : PlanItemWidget(
              planModel: planModel,
              getUserProfileModel: widget.getUserProfileModel,
            );
    }
  }
}

class PlanItemWidget extends StatelessWidget {
  PlanModel planModel;

  GetUserProfileModel getUserProfileModel;

  PlanItemWidget({this.planModel, this.getUserProfileModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PurchaseCoinsBackground(
      child: Column(
        children: [
          Container(
            height: size.height * 0.10,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfff576a4), Color(0xfff576a4)],
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("MY COINS",style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 22
                // ),),
                // SizedBox(
                //   height: 8,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      child: Image.asset("assets/images/coin.png"),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${getUserProfileModel.coins}",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    "In order to send more messages, receive more matches and for many more, buy coins",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10.0),
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: planModel.plans.length,
                    itemBuilder: (context, index) {
                      return PlanItemSection(
                        model: planModel.plans[index],
                        selectedIndex: index,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.09,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left:16.0,
                //       right: 16),
                //   child: GestureDetector(
                //     onTap: (){
                //       /* Navigator.push(context, MaterialPageRoute(builder: (context)
                //         => FinalStepScreen()));*/
                //     },
                //     child: Container(
                //       height: 40,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(16)),
                //           gradient: LinearGradient(
                //             colors: [
                //               Color(0xffEC407A),
                //               Color(0xffFD6296)
                //             ],
                //           )
                //       ),
                //       child: Center(
                //         child: Text("CONTINUE",
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold
                //           ),),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 8,
                // ),
                Text(
                  "When you select a gender each match costs 9 coins",
                  style: TextStyle(fontSize: 10, color: Color(0xff828282)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlanItemSection extends StatefulWidget {
  Plan model;
  int selectedIndex = 1;

  PlanItemSection({this.model, this.selectedIndex: 1});

  @override
  _PlanItemSectionState createState() => _PlanItemSectionState();
}

class _PlanItemSectionState extends State<PlanItemSection> {
  Razorpay _razorpay = Razorpay();

  BuildContext context;

  PaymentUpdateModel paymentUpdateModel;
  String userId;
  String paymentId;

  Token _paymentToken;
  PaymentMethod _paymentMethod;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _error;
  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
    name: 'Test User',
    cvc: '133',
    addressLine1: 'Address 1',
    addressLine2: 'Address 2',
    addressCity: 'City',
    addressState: 'CA',
    addressZip: '1337',
  );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return GestureDetector(
      onTap: () {
        //return openCheckout();
        //return showProgressIssue(context);
        return _settingModalBottomSheet(context);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 34,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: Image.asset("assets/images/coin.png"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${widget.model.coins}",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Rs ${widget.model.beforediscount}",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Rs ${widget.model.afterdiscount}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width / 3,
              child: Center(
                child: Container(
                  height: 25,
                  width: 122,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 0, right: 0),
                      child: Text(
                        "${widget.model.discountpercent}% discount",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> showProgressIssue(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return _dialogData();
        });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
                //color: AppConstant.backGroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))),
            child: _dialogData(),
          );
        });
  }

  Widget _dialogData() => Card(
        //insetPadding: EdgeInsets.only(left: 15.0, right: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        //backgroundColor: Colors.white,
        child: Container(
          height: 200,
          padding:
              EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
          //height: MediaQuery.of(context).size.height * 0.60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Choose a payment option",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              //Text("Subscribed our services at only Rs: 100",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.pop(context);
              //     return _makeStripePayment();
              //   },
              //   child: Container(
              //     height: 48,
              //     width: MediaQuery.of(context).size.width * 0.90,
              //     margin:
              //     EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              //     decoration: BoxDecoration(
              //         color: AppConstant.primaryColor,
              //         borderRadius:
              //         BorderRadius.all(Radius.circular(10.0))),
              //     child: Center(
              //       child: Text(
              //         "GPay".toUpperCase(),
              //         textScaleFactor: 0.9,
              //         style: TextStyle(
              //             color: Color(0xffFFFFFF),
              //             letterSpacing: 1.5,
              //             fontSize: 14.0),
              //       ),
              //     ),
              //   ),
              // ),
            /*  RaisedButton(
                child: Text("Create Token with Card"),
                onPressed: () {
               *//*   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardPayTest()),
                  );*//*

                  StripePayment.paymentRequestWithCardForm(
                      CardFormPaymentRequest())
                      .then((paymentMethod) {
                    setPay(paymentMethod);
                    _scaffoldKey.currentState.showSnackBar(

                        SnackBar(content: Text('Received ${paymentMethod.id}')));
                    setState(() {
                      _paymentMethod = paymentMethod;
                    });
                  }).catchError(setError);

              *//*    StripePayment.createTokenWithCard(
                    testCard,
                  ).then((token) {
                    setPay(token);
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Received ${token.tokenId}')));
                    setState(() {
                      _paymentToken = token;
                    });
                  }).catchError(setError);*//*
                },
              ),*/
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                 /* StripePayment.createTokenWithCard(
                    testCard,
                  ).then((token) {
                    setPay(token);
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Received ${token.tokenId}')));
                    setState(() {
                      _paymentToken = token;
                    });
                  }).catchError(setError);*/
                  StripePayment.paymentRequestWithCardForm(
                      CardFormPaymentRequest())
                      .then((paymentMethod) {
                    setPay(paymentMethod);
                    _scaffoldKey.currentState.showSnackBar(

                        SnackBar(content: Text('Received ${paymentMethod.id}')));
                    setState(() {
                      _paymentMethod = paymentMethod;
                    });
                  }).catchError(setError);
                /*  return openCheckout();*/
                },
                child: Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width * 0.90,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  decoration: BoxDecoration(
                      color: AppConstant.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Center(
                    child: Text(
                      "paynow".toUpperCase(),
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          letterSpacing: 1.5,
                          fontSize: 14.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

  PaymentUpdateModel getPaymentUpdateModel() => PaymentUpdateModel(
        //plan: widget.model.plan,
        coins: widget.model.coins,
        userId: userId,
        //beforediscount: widget.model.beforediscount,
        //afterdiscount: widget.model.afterdiscount,
        //discountpercent: widget.model.discountpercent,
   //     paymentId: paymentId,
    paymentId: "dummy",
    paymentType: "Strip",
        //planId: widget.model.id
      );

  @override
  void initState() {
    // TODO: implement initState
    getUserId();
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  void callApi() {
    ApiRepository.paymentUpdate(getPaymentUpdateModel()).then((value) {
      setState(() {});
      SHelper.showFlushBar("Payment", "Payment successfull", context);
    }).catchError((error) {
      SHelper.showFlushBar("Payment", "Payment not successfull", context);
    });
  }

  void getUserId() {
    SHelper.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    }).catchError((error) {});
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      paymentId = response.paymentId;
    });
    callApi();
    //SHelper.showFlushBar("Payment Success", "${response.paymentId}", context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    //print(jsonEncode(response.message["description"]));
    SHelper.showFlushBar("Payment Failure",
        response.code.toString() + " - " + response.message, context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    SHelper.showFlushBar("Payment Wallet", "${response.walletName}", context);
  }

  void openCheckout() async {
    var options = {
      'key': '${AppConstant.DEVELOPMENT_RAZORPAY_KEY}',
      'amount': double.parse(widget.model.afterdiscount) * 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  _makeStripePayment() async {
    var environment = 'rest'; // or 'production'

    if (!(await FlutterGooglePay.isAvailable(environment))) {
      //_showToast(scaffoldContext, 'Google pay not available');
      SHelper.showFlushBar("Google Play", 'Google pay not available', context);
    } else {
      PaymentItem pm = PaymentItem(
          stripeToken: 'pk_test_1IV5H8NyhgGYOeK6vYV3Qw8f',
          stripeVersion: "2018-11-08",
          currencyCode: "inr",
          amount: "${double.parse(widget.model.afterdiscount)}",
          gateway: 'stripe');

      FlutterGooglePay.makePayment(pm).then((Result result) {
        if (result.status == ResultStatus.SUCCESS) {
          callApi();
          //SHelper.showFlushBar("Google Play", 'Success', context);
          //_showToast(scaffoldContext, 'Success');
        }
      }).catchError((dynamic error) {
        SHelper.showFlushBar("Google Play", error.toString(), context);
        //_showToast(scaffoldContext, error.toString());
      });
    }
  }

  Future<String> setPay(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();


      int mAmount= int.parse(widget.model.afterdiscount)* 100;
    Response response = await http.post(
              Uri.parse("http://13.127.44.197:4600/api/transactions/create"),
              body: {
                "userId": preferences.getString("paymentId"),
                "planId":  widget.model.plan,
                "amount":mAmount.toString() ,
                "currency": "inr",
                "source": "tok_visa"
              });

    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      print("Siple static ${response.body}");
      callApi();
      var userdetails1 = JSON.jsonDecode(response.body);
    }
  }
}
