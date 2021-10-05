import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/dialog_utils.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/s/utils/quick_blox_local.dart';
import 'package:hookezy/s/utils/snackbar_utils.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';
class CallFragmentBody extends StatefulWidget {
  @override
  _CallFragmentBodyState createState() => _CallFragmentBodyState();
}

class _CallFragmentBodyState extends State<CallFragmentBody> with RouteAware, RouteObserverMixin{

  bool isError = false;
  bool isLoading = true;
  String accessToken;
  String userName;
  Size size;
  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();



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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // unsubscribeCall();
    // unsubscribeCallEnd();
    // unsubscribeReject();
    // unsubscribeAccept();
    // unsubscribeHangUp();
    // unsubscribeVideoTrack();
    // unsubscribeNotAnswer();
    // unsubscribePeerConnection();
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

  // Future<void> subscribeVideoTrack() async {
  //   if (_videoTrackSubscription != null) {
  //     SnackBarUtils.showResult(
  //         _scaffoldKey,
  //         "You already have a subscription for:" +
  //             QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
  //     return;
  //   }
  //
  //   try {
  //     _videoTrackSubscription = await QB.webrtc
  //         .subscribeRTCEvent(QBRTCEventTypes.RECEIVED_VIDEO_TRACK, (data) {
  //       Map<String, Object> payloadMap =
  //       new Map<String, Object>.from(data["payload"]);
  //
  //       int opponentId = payloadMap["userId"];
  //
  //       if (opponentId == LOGGED_USER_ID) {
  //         startRenderingLocal();
  //       } else {
  //         startRenderingRemote(opponentId);
  //       }
  //     }, onErrorMethod: (error) {
  //       DialogUtils.showError(context, error);
  //     });
  //     SnackBarUtils.showResult(
  //         _scaffoldKey, "Subscribed: " + QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
  //   } on PlatformException catch (e) {
  //     DialogUtils.showError(context, e);
  //   }
  // }

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

  void getTOKEN(){
    setState(() {
      isLoading = true;
      isError = false;
    });
    SHelper.getUsername().then((value) {
      setState(() {
        userName = value;
      });
      return ApiRepository.getAccessToken(value);
    }).then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        accessToken = value.data["token"];
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
        isError = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getTOKEN();
    //startQuickMain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: pink,
        title: Text("Call",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: uiPayload(),
    );
  }

  void startQuickMain(){
    SHelper.getQuickBloxUserId().then((value) {
      return QuickBloxLocal.connectChat(value);
    }).then((value) {
      print("Hollllll");
      subscribeQuick();
    });
  }

  Widget uiPayload(){
    if(isError){
      return ErrorScreen(onRefresh: (){return getTOKEN();},);
    }else if(isLoading){
      return ProgressLoader(title: "Fetching Data...",);
    }else {
      return Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        kPrimaryColor,
                        kPrimaryLightColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
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
                        Container(
                            height: 40,
                            width: 110,
                            decoration: BoxDecoration(
                              color: pink,
                              borderRadius:
                              BorderRadius.all(Radius.circular(7)),),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 16,
                                          width: 16,
                                          child: Image.asset("assets/images/key.png")),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Female",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ],
                                  )),
                            )),

                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height/4.9,
                  ),
                  Container(
                    height: size.height/3.5,
                    width: size.width/1.5,
                    child: Image.asset("assets/images/callimage.png"),
                  )                ],
              ),
            ),
          ),
        ],
      );
    }
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
    print("i am dasss");

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

}
