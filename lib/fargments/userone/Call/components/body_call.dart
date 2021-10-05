import 'dart:async';


import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/quickblox_video.dart';

import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/model/random_user_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/dialog_utils.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/s/utils/quick_blox_local.dart';
import 'package:hookezy/s/utils/snackbar_utils.dart';
import 'package:hookezy/screens/final_step/components/body_final_step.dart';

import 'package:hookezy/screens/purchase_coins/components/body_purchase_coins.dart';

import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';


class CallFragmentBody extends StatefulWidget {
  static String gender = "Female";
  static int GenderV = 0;
  @override
  _CallFragmentBodyState createState() => _CallFragmentBodyState();

   static void refreshDatas() async {
    if (MyDialog.selectedRadioTile == 1) {
      gender = "Male";
      GenderV = 0;
      print("hdgjhdgkhdfkjhfk");
    } else if (MyDialog.selectedRadioTile == 2) {
      gender = "Male";
      GenderV = 1;
      print("aaaaaaaaaaaaaaaaaaaaaaaa");
    } else {
      gender = "Both";
      GenderV = 2;
      print("bbbbbbbbbbbbbbbbbbbb");
    }
  }
}

class _CallFragmentBodyState extends State<CallFragmentBody> with RouteAware, RouteObserverMixin{
  String _selectedId;
  GetUserProfileModel getUserProfileModel;
  bool isError = false;
  bool isLoading = true;
  Timer _timer;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  int quId;
  RandomUserModel randomUserModel;
  SharedPreferences prefs;
  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();



  String accessToken;
  String userName;
  Size size;

  String _sessionId;

  RTCVideoViewController _localVideoViewController;
  RTCVideoViewController _remoteVideoViewController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  bool _videoCall = true;

  StreamSubscription _callSubscription;
  StreamSubscription _callEndSubscription;
  StreamSubscription _rejectSubscription;
  StreamSubscription _acceptSubscription;
  StreamSubscription _hangUpSubscription;
  StreamSubscription _videoTrackSubscription;
  StreamSubscription _notAnswerSubscription;
  StreamSubscription _peerConnectionSubscription;

  Future<String> getHost() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("localGender");
  }

  void getProfileModel() {
    ApiRepository.getUserProfile(319).then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        getUserProfileModel = value;
      });
      return SHelper.getUsername();
    }).then((value) {
      setState(() {
        userName = value;
      });
      //return ApiRepository.getAccessToken(value);
      return ApiRepository.getRandomUser();
    }).then((value) {
      setState(() {
        randomUserModel = value;
      });

      return ApiRepository.getAccessToken(value.name);
    }).then((value) {
      setState(() {

        accessToken = value.data["token"];
      });
      return getHost();
    }).then((value) {
      print("Main Gender is ${value}");
      setState(() {
        isLoading = false;
        isError = false;
        CallFragmentBody.gender = value;
        if(value == "Female"){
          MyDialog.selectedRadioTile = 1;
          genderValue = 1;
          gender = "Female";
        }else if(value == "Male"){
          MyDialog.selectedRadioTile = 2;
          genderValue = 2;
          gender = "Male";
        }else{
          genderValue = 3;
          gender = "Both";
          MyDialog.selectedRadioTile = 3;
        }
      });
      print(CallFragmentBody.gender);
    }).catchError((error) {
      setState(() {
        isLoading = false;
        isError = true;
        getUserProfileModel = null;
      });
    });
  }

  // @override
  // void initState() {
  //
  // }
  String gender = "Female";
  int genderValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    getProfileModel();
    //runTimer();
    //startQuickMain();
    super.initState();
  }

  void subscribeQuick(){
    subscribeCall();
    subscribeCallEnd();
    subscribeReject();
    subscribeAccept();
    subscribeHangUp();
    //subscribeVideoTrack();
    subscribeNotAnswer();
    subscribePeerConnection();
  }


  String parseState(int state) {
    String parsedState = "";

    switch (state) {
      case QBRTCPeerConnectionStates.NEW:
        parsedState = "NEW";
        break;
      case QBRTCPeerConnectionStates.FAILED:
        parsedState = "FAILED";
        break;
      case QBRTCPeerConnectionStates.DISCONNECTED:
        parsedState = "DISCONNECTED";
        break;
      case QBRTCPeerConnectionStates.CLOSED:
        parsedState = "CLOSED";
        break;
      case QBRTCPeerConnectionStates.CONNECTED:
        parsedState = "CONNECTED";
        break;
    }

    return parsedState;
  }



  Future<void> subscribeCall() async {
    if (_callSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.CALL);
      return;
    }

    try {
      _callSubscription =
      await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL, (data) {
        Map<String, Object> payloadMap =
        new Map<String, Object>.from(data["payload"]);

        Map<String, Object> sessionMap =
        new Map<String, Object>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];
        int initiatorId = sessionMap["initiatorId"];
        int callType = sessionMap["type"];
        print("hollaaa i am receiving call from sourav");
        setState(() {
          if (callType == QBRTCSessionTypes.AUDIO) {
            _videoCall = false;
          } else {
            _videoCall = true;
          }
        });

        _sessionId = sessionId;
        String messageCallType = _videoCall ? "Video" : "Audio";
        // flush = new Flushbar(
        //   message: "You are receiving an incoming call",
        //   icon: Icon(
        //     Icons.info_outline,
        //     size: 28.0,
        //     color: Colors.blue[300],
        //   ),
        //   //duration: Duration(seconds: 3),
        //   flushbarPosition: FlushbarPosition.TOP,
        //   leftBarIndicatorColor: Colors.blue[300],
        //   mainButton: TextButton(onPressed: (){ flush.dismiss(true);rejectWebRTC(_sessionId);}, child: Text("Accept")),
        // )..show(context);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             // CallPage(
        //             //   channelName: "${randomUserModel.name}",
        //             //   accessToken: accessToken,
        //             //   coins: AppConstant.HOME_COINS_PRICE,
        //             //   isVideoEnable: false,
        //             // )
        //       QuickVideo()
        //     ));

        DialogUtils.showTwoBtn(context,
            "The INCOMING $messageCallType call from user $initiatorId",
                (accept) {
              acceptWebRTC(sessionId);
            }, (decline) {
              rejectWebRTC(sessionId);
            });
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.CALL);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> acceptWebRTC(String sessionId) async {
    try {
      QBRTCSession session = await QB.webrtc.accept(sessionId);
      String receivedSessionId = session.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $receivedSessionId was accepted");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> rejectWebRTC(String sessionId) async {
    try {
      QBRTCSession session = await QB.webrtc.reject(sessionId);
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $_sessionId was rejected");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeCallEnd() async {
    if (_callEndSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.CALL_END);
      return;
    }
    try {
      _callEndSubscription =
      await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL_END, (data) {
        Map<String, Object> payloadMap =
        new Map<String, Object>.from(data["payload"]);

        Map<String, Object> sessionMap =
        new Map<String, Object>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];

        SnackBarUtils.showResult(
            _scaffoldKey, "The call with sessionId $sessionId was ended");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.CALL_END);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }



  Future<void> subscribeNotAnswer() async {
    if (_notAnswerSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.NOT_ANSWER);
      return;
    }

    try {
      _notAnswerSubscription =
      await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.NOT_ANSWER, (data) {
        int userId = data["payload"]["userId"];
        DialogUtils.showOneBtn(context, "The user $userId is not answer");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.NOT_ANSWER);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeReject() async {
    if (_rejectSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.REJECT);
      return;
    }

    try {
      _rejectSubscription =
      await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.REJECT, (data) {
        int userId = data["payload"]["userId"];
        DialogUtils.showOneBtn(
            context, "The user $userId was rejected your call");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.REJECT);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeAccept() async {
    if (_acceptSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.ACCEPT);
      return;
    }

    try {
      _acceptSubscription =
      await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.ACCEPT, (data) {
        int userId = data["payload"]["userId"];
        SnackBarUtils.showResult(
            _scaffoldKey, "The user $userId was accepted your call");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.ACCEPT);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeHangUp() async {
    if (_hangUpSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.HANG_UP);
      return;
    }

    try {
      _hangUpSubscription =
      await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.HANG_UP, (data) {
        int userId = data["payload"]["userId"];
        DialogUtils.showOneBtn(context, "the user $userId is hang up");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.HANG_UP);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribePeerConnection() async {
    if (_peerConnectionSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
      return;
    }

    try {
      _peerConnectionSubscription = await QB.webrtc.subscribeRTCEvent(
          QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED, (data) {
        int state = data["payload"]["state"];
        String parsedState = parseState(state);
        SnackBarUtils.showResult(
            _scaffoldKey, "PeerConnection state: $parsedState");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(_scaffoldKey,
          "Subscribed: " + QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeCall() {
    if (_callSubscription != null) {
      _callSubscription.cancel();
      _callSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.CALL);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.CALL);
    }
  }

  void unsubscribeCallEnd() {
    if (_callEndSubscription != null) {
      _callEndSubscription.cancel();
      _callEndSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.CALL_END);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.CALL_END);
    }
  }

  void unsubscribeReject() {
    if (_rejectSubscription != null) {
      _rejectSubscription.cancel();
      _rejectSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.REJECT);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.REJECT);
    }
  }

  void unsubscribeAccept() {
    if (_acceptSubscription != null) {
      _acceptSubscription.cancel();
      _acceptSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.ACCEPT);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.ACCEPT);
    }
  }

  void unsubscribeHangUp() {
    if (_hangUpSubscription != null) {
      _hangUpSubscription.cancel();
      _hangUpSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.HANG_UP);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.HANG_UP);
    }
  }

  void unsubscribeVideoTrack() {
    if (_videoTrackSubscription != null) {
      _videoTrackSubscription.cancel();
      _videoTrackSubscription = null;
      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
    }
  }

  void unsubscribeNotAnswer() {
    if (_notAnswerSubscription != null) {
      _notAnswerSubscription.cancel();
      _notAnswerSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.NOT_ANSWER);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.NOT_ANSWER);
    }
  }

  void unsubscribePeerConnection() {
    if (_peerConnectionSubscription != null) {
      _peerConnectionSubscription.cancel();
      _peerConnectionSubscription = null;
      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
    }
  }

  void startQuickMain(){
    SHelper.getQuickBloxUserId().then((value) {
      return QuickBloxLocal.connectChat(value);
    }).then((value) {
      print("Hollllll");
      subscribeQuick();
    });
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: pink,
        title: Text(
          "Call",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: updateUI(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    unsubscribeCall();
    unsubscribeCallEnd();
    unsubscribeReject();
    unsubscribeAccept();
    unsubscribeHangUp();
    unsubscribeVideoTrack();
    unsubscribeNotAnswer();
    unsubscribePeerConnection();
  }

  Future<bool> saveGender(String gender) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("localGender", gender);
    return true;
  }
  
  void makeCall(){
    SHelper.getQuickBloxUserId().then((value) {
      setState(() {
        quId = value;
      });
      print("Make Call ${value}");
      return QuickBloxLocal.connectChat(value);
    }).then((value) {
      return QuickBloxLocal.initiateFinalCall(QBRTCSessionTypes.VIDEO,randomUserModel.uuid);
    }).catchError((error){
      print(" ${error.toString()}");
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    //print("i am data");
    //fetchUserData();
    print("myida");
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    print("i am dasssssss");
    //startQuickMain();
    //startQuickMain();
    super.didPopNext();
  }

  @override
  void didPush() { print("familyy push"); }

  /// Called when the current route has been popped off.
  @override
  void didPop() { print("familyy pop");}

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @override
  void didPushNext(){
  }

  Widget updateUI() {
    if (isError) {
      return ErrorScreen(
        onRefresh: () {},
      );
    } else if (isLoading == true) {
      return ProgressLoader(
        title: "Fetching Data...",
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                kPrimaryColor,
                kPrimaryLightColor,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),

                  Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            /* showDialog(
                                context: context,
                                child: MyDialog(
                                  onValueChange: _onValueChange,
                                ));*/
                            openChoiceDialog(context);
                          },
                          child: Container(
                              height: 40,
                              width: 110,
                              decoration: BoxDecoration(
                                color: pink,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 16,
                                        width: 16,
                                        child: Image.asset(
                                            "assets/images/key.png")),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      gender,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PurchaseCoinsBody(
                                          getUserProfileModel:
                                              getUserProfileModel,
                                        )));
                          },
                          child: Container(
                              height: 40,
                              width: 110,
                              decoration: BoxDecoration(
                                color: pink,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 16,
                                        width: 16,
                                        child: Image.asset(
                                            "assets/images/coin.png")),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "${getUserProfileModel.coinss}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 4.9,
                  ),
                  GestureDetector(
                    onTap: () async{
                      //await QuickBloxLocal.connectChat()
                      //QuickBloxLocal.initVideoCall();
                      //openChoiceDialog(context);
                      if(getUserProfileModel.coinss > AppConstant.HOME_COINS_PRICE){
                        if(randomUserModel.uuid != null){
                          makeCall();
                        }else{
                          Flushbar(
                            title: "Call",
                            backgroundColor: Colors.red,
                            message: "Unable to get UUID",
                            flushbarPosition: FlushbarPosition.TOP,
                            duration: Duration(seconds: 3),
                          )..show(context);
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             // CallPage(
                        //             //   channelName: "${randomUserModel.name}",
                        //             //   accessToken: accessToken,
                        //             //   coins: AppConstant.HOME_COINS_PRICE,
                        //             //   isVideoEnable: false,
                        //             // )
                        //       QuickVideo()
                        //     ));
                      }else {
                        Flushbar(
                          title: "Coins",
                          backgroundColor: Colors.red,
                          message: "You do not have enough coins to make calls",
                          flushbarPosition: FlushbarPosition.TOP,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      }
                      //return QuickBloxLocal.initiateFinalCall(QBRTCSessionTypes.AUDIO);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             // CallPage(
                      //             //   channelName: "${randomUserModel.name}",
                      //             //   accessToken: accessToken,
                      //             //   coins: AppConstant.HOME_COINS_PRICE,
                      //             //   isVideoEnable: false,
                      //             // )
                      //       QuickVideo()
                      //     ));
                    },
                    child: Container(
                      height: size.height / 3.5,
                      width: size.width / 1.5,
                      child: Image.asset("assets/images/callimage.png"),
                    ),
                  ),
                  Text("${quId}")
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }



  void runTimer() {
    print("Running.... ${endTime}");
    CountdownTimer(
      endTime: endTime,
      onEnd: () {
        print("ioioio");
      },
      widgetBuilder: (_, CurrentRemainingTime time) {
        if (time == null) {
          return Text('Game over');
        }
        return Text(
            'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
      },
    );
  }

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(
        const Duration(seconds: 30000),
            (Timer timer) => setState(
              () {
            if (AppConstant.VIDEO_TIMER < 1) {
              timer.cancel();
            } else {
              AppConstant.VIDEO_TIMER - 1;
            }
          },
        ),
      );
    }
  }


  void openChoiceDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Align(
            child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                backgroundColor: Colors.transparent,
                content: Wrap(
                  children: <Widget>[
                    Container(
                      // height: 115,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(18.0),
                        color: Colors.white,
                      ),

                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    kPrimaryLightColor,
                                    kPrimaryColor,
                                  ],
                                )),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "DO YOU WANT TO TALK TO ?",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Female',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'comfortaa_semibold'),
                                  ),
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 1,
                                    groupValue: genderValue,
                                    activeColor: kPrimaryColor,
                                    onChanged: (val) {
                                      Navigator.of(context).pop(); // Line 1
                                      openChoiceDialog(context);
                                      print("Radio $val");
                                      setSelectedRadioTile(val);
                                      setState(() {
                                        gender = "Female";
                                        genderValue = 1;
                                      });
                                      saveGender("Female");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Male',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'comfortaa_semibold'),
                                  ),
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 2,
                                    groupValue: genderValue,
                                    activeColor: kPrimaryColor,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadioTile(val);
                                      setState(() {
                                        gender = "Male";
                                        genderValue = 2;
                                      });
                                      saveGender("Male");
                                      Navigator.of(context).pop(); // Line 1
                                      openChoiceDialog(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Both',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'comfortaa_semibold'),
                                  ),
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 3,
                                    groupValue: genderValue,
                                    activeColor: kPrimaryColor,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadioTile(val);
                                      setState(() {
                                        gender = "Both";
                                        genderValue = 3;
                                      });
                                      saveGender("Both");
                                      Navigator.of(context).pop(); // Line 1
                                      openChoiceDialog(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                /* Navigator.push( context, MaterialPageRoute( builder: (context) => HomeBody()), ).then((value) => setState(() {}));*/
                                /* Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)
                          => HomeBody()), (Route<dynamic> route) => false);*/

                                print("CHOICE = " + CallFragmentBody.gender);
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Center(
                                    child: Text(
                                  "OKAY",
                                  style: TextStyle(
                                    //color: Color(0xffec407a),
                                    fontFamily: 'comfortaa_semibold',
                                    fontSize: 18,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  static int selectedRadioTile;
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({this.onValueChange, this.initialValue});
  static int selectedRadioTile;
  final String initialValue;
  final void Function(String) onValueChange;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String _selectedId;
  String choice;

  setSelectedRadioTile(int val) {
    print("Gender is d ${val}");
    setState(() {
      MyDialog.selectedRadioTile = val;
    });
  }

  @override
  void initState() {

    super.initState();
    _selectedId = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return Align(
      child: AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          content: Wrap(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                kPrimaryLightColor,
                                kPrimaryColor,
                              ],
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "DO YOU WANT TO TALK TO ?",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Female',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'comfortaa_semibold'),
                              ),
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: CallFragmentBody.gender,
                                groupValue: MyDialog.selectedRadioTile,
                                activeColor: kPrimaryColor,
                                onChanged: (val) {
                                  print("Radio $val");
                                  setSelectedRadioTile(val);
                                  setState(() {
                                    CallFragmentBody.gender = "Female";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Male',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'comfortaa_semibold'),
                              ),
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: CallFragmentBody.gender,
                                groupValue: MyDialog.selectedRadioTile,
                                activeColor: kPrimaryColor,
                                onChanged: (val) {
                                  print("Radio $val");
                                  setSelectedRadioTile(val);
                                  setState(() {
                                    CallFragmentBody.gender = "Male";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Both',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'comfortaa_semibold'),
                              ),
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: CallFragmentBody.gender,
                                groupValue: MyDialog.selectedRadioTile,
                                activeColor: kPrimaryColor,
                                onChanged: (val) {
                                  print("Radio $val");
                                  setSelectedRadioTile(val);
                                  setState(() {
                                    CallFragmentBody.gender = "Both";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            /* Navigator.push( context, MaterialPageRoute( builder: (context) => HomeBody()), ).then((value) => setState(() {}));*/
                            /* Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)
                            => HomeBody()), (Route<dynamic> route) => false);*/
                            print("CHOICE = " + CallFragmentBody.gender);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Center(
                                child: Text(
                              "OKAY",
                              style: TextStyle(
                                //color: Color(0xffec407a),
                                fontFamily: 'comfortaa_semibold',
                                fontSize: 18,
                              ),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                    ],
                  )),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("DISPOSE");
    //CallFragmentBody.refreshData();
  }


}
