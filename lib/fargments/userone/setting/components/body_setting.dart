import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userone/setting/components/background_settings.dart';
import 'package:hookezy/s/blocked_list.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/screens/general/general_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class UseroneSettingBody extends StatefulWidget {
  String gender;

  UseroneSettingBody({this.gender});

  @override
  _UseroneSettingBodyState createState() => _UseroneSettingBodyState();
}

class _UseroneSettingBodyState extends State<UseroneSettingBody> {
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


  static int selectedAmount;
  Razorpay _razorpay = Razorpay();
  SharedPreferences prefs;
  bool isLoading = true;
  bool isHost = false;
  String gender;

  @override
  void initState() {
    // TODO: implement initState
    setHostAc();
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  Future<List<dynamic>> getHost() async {
    prefs = await SharedPreferences.getInstance();
    return [prefs.getString("userRole"), prefs.getString("localGender")];
  }

  void setHostAc() {
    getHost().then((value) {
      print("simsss ${value}");
      setState(() {
        isHost = value[0] == "Host" ? true : false;
        gender = value[1];
        isLoading = false;
      });
    }).catchError((error) {
      isHost = false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xfff576a4),
          title: Text("Settings",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: 'comfortaa_semibold')),
        ),
        body: isLoading == true
            ? ProgressLoader(
                title: "Please Wait...",
              )
            : UseroneSettingBackground(
                child: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
//BLOCKKED USERS................................................................
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlockedListUI()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xffE5E5E5),
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Blocked Users",
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Color(0xffEC407A),
                                      fontFamily: 'comfortaa_semibold'),
                                ),
                                Container(
                                  height: 12,
                                  width: 12,
                                  child: Image.asset(
                                      "assets/images/rightarrow.png"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),

//GENDER PREFERENCES...........................................................
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "GENDER PREFERENCES",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffEC407A),
                              fontFamily: 'comfortaa_semibold'),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xffE5E5E5),
                        child: Column(
                          children: [
//MALE..........................................................................
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8.0),
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "MALE",
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color: Color(0xffEC407A),
                                          fontFamily: 'comfortaa_semibold'),
                                    ),
                                    if (gender == "Male")
                                      Icon(
                                        Icons.check,
                                        color: AppConstant.primaryColor,
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8),
                              child: Divider(
                                color: Color(0xffEC407A).withOpacity(0.24),
                                height: 1,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
//FEMALE........................................................................
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8.0),
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "FEMALE",
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color: Color(0xffEC407A),
                                          fontFamily: 'comfortaa_semibold'),
                                    ),
                                    if (gender == "Female")
                                      Icon(
                                        Icons.check,
                                        color: AppConstant.primaryColor,
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8),
                              child: Divider(
                                color: Color(0xffEC407A).withOpacity(0.24),
                                height: 1,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),

//BOTH..........................................................................
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8.0),
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "BOTH",
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color: Color(0xffEC407A),
                                          fontFamily: 'comfortaa_semibold'),
                                    ),
                                    if (gender == "Both")
                                      Icon(
                                        Icons.check,
                                        color: AppConstant.primaryColor,
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8),
                              child: Divider(
                                color: Color(0xffEC407A).withOpacity(0.24),
                                height: 1,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      //CONTACT US...........................................................
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "CONTACT US",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffEC407A),
                              fontFamily: 'comfortaa_semibold'),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xffE5E5E5),
                        height: 50,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Help and Support",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0xffEC407A),
                                    fontFamily: 'comfortaa_semibold'),
                              ),
                              Container(
                                height: 12,
                                width: 12,
                                child:
                                    Image.asset("assets/images/rightarrow.png"),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),

//LEGAL...........................................................
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "LEGAL",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffEC407A),
                              fontFamily: 'comfortaa_semibold'),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xffE5E5E5),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8.0),
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color: Color(0xffEC407A),
                                          fontFamily: 'comfortaa_semibold'),
                                    ),
                                    Container(
                                      height: 12,
                                      width: 12,
                                      child: Image.asset(
                                          "assets/images/rightarrow.png"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8),
                              child: Divider(
                                color: Color(0xffEC407A).withOpacity(0.24),
                                height: 1,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
//TEarms of use.................................................................
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8.0),
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Tearms Of Use",
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color: Color(0xffEC407A),
                                          fontFamily: 'comfortaa_semibold'),
                                    ),
                                    Container(
                                      height: 12,
                                      width: 12,
                                      child: Image.asset(
                                          "assets/images/rightarrow.png"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8),
                              child: Divider(
                                color: Color(0xffEC407A).withOpacity(0.24),
                                height: 1,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),

//COMMUNITY GUIDELINES..........................................................................
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8.0),
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "COMMUNITY GUIDELINES",
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color: Color(0xffEC407A),
                                          fontFamily: 'comfortaa_semibold'),
                                    ),
                                    Container(
                                      height: 12,
                                      width: 12,
                                      child: Image.asset(
                                          "assets/images/rightarrow.png"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8),
                              child: Divider(
                                color: Color(0xffEC407A).withOpacity(0.24),
                                height: 1,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),

//SUBSCRIPTION...........................................................
                      if (isHost == false)
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            "SUBSCRIPTION",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffEC407A),
                                fontFamily: 'comfortaa_semibold'),
                          ),
                        ),
                      if (isHost == false)
                        SizedBox(
                          height: 16,
                        ),
                      if (isHost == false)
                        GestureDetector(
                          onTap: () async {
                            String v = await SHelper.getPremium();
                            print(v);
                            if (v == "Premium") {
                              showProgress(context);
                              //zshowDialogPay();
                            } else {
                              showDialogPay();
                              //showProgressIssue(context);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xffE5E5E5),
                            height: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Check Subscription Status",
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Color(0xffEC407A),
                                        fontFamily: 'comfortaa_semibold'),
                                  ),
                                  Container(
                                    height: 12,
                                    width: 12,
                                    child: Image.asset(
                                        "assets/images/rightarrow.png"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ));
  }

  static Future<dynamic> showProgress(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ShowPremiumDialog();
        });
  }

  Future<dynamic> showProgressIssue(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ShowPremiumDialogIssue(
            onClick: () {
              Navigator.pop(context);
              return openCheckout();
            },
          );
        });
  }

  void callApi() async {
    // ApiRepository.makePremium().then((value) {
    //
    //   SHelper.showFlushBar("Payment", "Payment successfull", context);
    // }).catchError((error){
    //   SHelper.showFlushBar("Payment", "Payment not successfull", context);
    // });
    try {
      final v = await ApiRepository.makePremium();
      prefs = await SharedPreferences.getInstance();
      prefs.setString("userRole", "Premium");
      print("rttrt ${v.data}");
      // Navigator.of(context)
      //     .popUntil(ModalRoute.withName(HomeScreen().toString()));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      SHelper.showFlushBar("Payment", "Payment successfull", context);
    } catch (error) {
      SHelper.showFlushBar("Payment", "Payment not successfull", context);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
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
      'amount': 100,
      'name': 'HookEzy.',
      'description': 'Premium Services',
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

  void showDialogPay() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 200,
            padding: EdgeInsets.only(
                top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scaffold(
                body: Container(
                  child: Container(
                    //height: MediaQuery.of(context).size.height * 0.60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "You are not a premium user",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                       /* Text(
                          "Subscribed our services at only Rs: 100",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                // onTap: onClick,
                                onTap: () {
                                  showAlertDialog(context);
                                },
                                child: Container(
                                  height: 48,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  margin: EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 10.0),
                                  decoration: BoxDecoration(
                                      color: AppConstant.primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Center(
                                    child: Text(
                                      "View Plans".toUpperCase(),
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          letterSpacing: 1.5,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 48,
                                width: MediaQuery.of(context).size.width * 0.5,
                                margin: EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 10.0),
                                decoration: BoxDecoration(
                                    color: AppConstant.primaryColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Center(
                                  child: Text(
                                    "Cancel".toUpperCase(),
                                    textScaleFactor: 0.9,
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        letterSpacing: 1.5,
                                        fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        StripePayment.paymentRequestWithCardForm(
                            CardFormPaymentRequest())
                            .then((paymentMethod) {
                          setPay(399,"1");
                          _scaffoldKey.currentState.showSnackBar(


                              SnackBar(content: Text('Received ${paymentMethod.id}')));
                          setState(() {
                            _paymentMethod = paymentMethod;
                          });
                        }).catchError(setError);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 7,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConstant.primaryColor, width: 2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Per Month',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '\u20B9399.0',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppConstant.primaryColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "SUBSCRIBE".toUpperCase(),
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          letterSpacing: 1.5,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        StripePayment.paymentRequestWithCardForm(
                            CardFormPaymentRequest())
                            .then((paymentMethod) {
                          setPay(999,"2");
                          _scaffoldKey.currentState.showSnackBar(


                              SnackBar(content: Text('Received ${paymentMethod.id}')));
                          setState(() {
                            _paymentMethod = paymentMethod;
                          });
                        }).catchError(setError);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 7,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConstant.primaryColor, width: 2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '3 Months',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '\u20B9999.0',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppConstant.primaryColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "SUBSCRIBE".toUpperCase(),
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          letterSpacing: 1.5,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        StripePayment.paymentRequestWithCardForm(
                            CardFormPaymentRequest())
                            .then((paymentMethod) {
                          setPay(2599,"3");
                          _scaffoldKey.currentState.showSnackBar(


                              SnackBar(content: Text('Received ${paymentMethod.id}')));
                          setState(() {
                            _paymentMethod = paymentMethod;
                          });
                        }).catchError(setError);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 7,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConstant.primaryColor, width: 2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '6 Months',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '\u20B92599.0',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppConstant.primaryColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "SUBSCRIBE".toUpperCase(),
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          letterSpacing: 1.5,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        StripePayment.paymentRequestWithCardForm(
                            CardFormPaymentRequest())
                            .then((paymentMethod) {
                          setPay(4000,"4");
                          _scaffoldKey.currentState.showSnackBar(


                              SnackBar(content: Text('Received ${paymentMethod.id}')));
                          setState(() {
                            _paymentMethod = paymentMethod;
                          });
                        }).catchError(setError);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 7,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConstant.primaryColor, width: 2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Per Year',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '\u20B94000.0',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppConstant.primaryColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "SUBSCRIBE".toUpperCase(),
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          letterSpacing: 1.5,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void setError(dynamic error) {}

  Future<String> setPay(int amount,String planId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int mAmount = amount * 100;
    http.Response response = await http.post(
        Uri.parse("http://13.127.44.197:4600/api/transactions/create"),
        body: {
          "userId": preferences.getString("paymentId"),
          "planId": planId,
          "amount": mAmount.toString(),
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

class ShowPremiumDialogIssue extends StatelessWidget {
  Object onClick;

  ShowPremiumDialogIssue({this.onClick});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 15.0, right: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        height: 200,
        padding:
            EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
        //height: MediaQuery.of(context).size.height * 0.60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "You are not a premium user",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              "Subscribed our services at only Rs: 100",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    // onTap: onClick,
                    onTap: () {
                      //showAlertDialog(context);
                    },
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                      decoration: BoxDecoration(
                          color: AppConstant.primaryColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Center(
                        child: Text(
                          "Pay".toUpperCase(),
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              letterSpacing: 1.5,
                              fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                    decoration: BoxDecoration(
                        color: AppConstant.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Center(
                      child: Text(
                        "Cancel".toUpperCase(),
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            letterSpacing: 1.5,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShowPremiumDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 15.0, right: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        height: 200,
        padding:
            EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
        //height: MediaQuery.of(context).size.height * 0.60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "You are already a premium user",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              "Enjoy Premium Services",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            GestureDetector(
              onTap: () {
                return Navigator.pop(context);
              },
              child: Container(
                height: 48,
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                decoration: BoxDecoration(
                    color: AppConstant.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Center(
                  child: Text(
                    "Ok".toUpperCase(),
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        letterSpacing: 1.5,
                        fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


