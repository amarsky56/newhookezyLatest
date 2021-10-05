import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/s/countdown_timer.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/dialog_utils.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/s/utils/snackbar_utils.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';


class QuickVideo extends StatefulWidget {

  String sessionId;
   QuickVideo({Key key,this.sessionId}) : super(key: key);

  @override
  _QuickVideoState createState() => _QuickVideoState();
}

class _QuickVideoState extends State<QuickVideo> {

  RTCVideoViewController _localVideoViewController;
  RTCVideoViewController _remoteVideoViewController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _sessionId;
  int LOGGED_USER_ID;
  int OPPONENT_ID;
  bool showTimer = true;

  bool _videoCall = true;
  bool isLocalFull = false;
  bool isExtraHide = false;

  StreamSubscription _callSubscription;
  StreamSubscription _callEndSubscription;
  StreamSubscription _rejectSubscription;
  StreamSubscription _acceptSubscription;
  StreamSubscription _hangUpSubscription;
  StreamSubscription _videoTrackSubscription;
  StreamSubscription _notAnswerSubscription;
  StreamSubscription _peerConnectionSubscription;
  int duration = 0;
  int preserveLast = 0;
  Timer _timer;

  Widget willNull = Container(child: Text("Hola"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("VIDEO"),backgroundColor: Colors.black,elevation: 0.0,),
      body: acceptPayload(),
    );
  }

  void logUserId(){
    SHelper.getQuickBloxUserId().then((value) {
      setState(() {
        LOGGED_USER_ID = value;
      });
      subscribeVideoTrack();
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    // subscribeCall();
    // subscribeCallEnd();
    // subscribeReject();
    // subscribeAccept();
    // subscribeHangUp();
    logUserId();
    enableVideo(false);
    // //subscribeVideoTrack();
    // subscribeNotAnswer();
    // subscribePeerConnection();
  }

  void subscribleALl(){
    logUserId();
    // subscribeCall();
    // subscribeCallEnd();
    // subscribeReject();
    // subscribeAccept();
    // subscribeHangUp();
    // //subscribeVideoTrack();
    // subscribeNotAnswer();
    // subscribePeerConnection();
  }

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

  // void deductCoins(int coins){
  //   ApiRepository.deductCoins(coins).then((value) {
  //     setState(() {
  //       //getUserProfileModel.coinss = getUserProfileModel.coinss -  widget.coins;
  //       //coindLess = getUserProfileModel.coinss < widget.coins;
  //     });
  //     //print("65675757 ${getUserProfileModel.coinss} ${widget.coins} ${getUserProfileModel.coinss < widget.coins}");
  //     //if(coindLess)_engine.destroy();
  //     //coindLess == true ? showDialog(context: context, barrierDismissible:false,builder: (BuildContext context) => erroDialog()) : null;
  //     //if(_engine != null )_engine.enableAudio();
  //     //print("tyrtrtrt ${getUserProfileModel.coinss}");
  //     //deductCoins(preserveLast);
  //     Navigator.pop(context);
  //   }).catchError((error){
  //
  //   });
  // }

  Widget runTimer() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
          child: Center(
            child: CountDownTimer(
              secondsRemaining: AppConstant.VIDEO_TIMER,
              whenTimeExpires: (){
                //_on30SeconsVideo();
                enableVideo(true);
                //subscribeVideoTrack();
                setState(() {
                  showTimer = false;
                });
              },
              countDownTimerStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 17.0,
                  height: 1.2
              ),
            ),
          )
      ),
    );
  }

  void _onLocalVideoViewCreated(RTCVideoViewController controller) {
    _localVideoViewController = controller;
  }

  void _onRemoteVideoViewCreated(RTCVideoViewController controller) {
    _remoteVideoViewController = controller;
  }

  Future<void> startRenderingLocal() async {
    try {
      await _localVideoViewController.play(widget.sessionId, LOGGED_USER_ID);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> startRenderingRemote(int opponentId) async {
    try {
      await _remoteVideoViewController.play(widget.sessionId, opponentId);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
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
        _sessionId = sessionId;
        print("hollaaa i am receiving call from sourav");
        setState(() {
          if (callType == QBRTCSessionTypes.AUDIO) {
            OPPONENT_ID = initiatorId;
            _videoCall = false;
            willNull = incomingPayload(initiatorId, "Audio", sessionId);
          } else {
            _videoCall = true;
            willNull = incomingPayload(initiatorId, "Video", sessionId);
          }
        });


        String messageCallType = _videoCall ? "Video" : "Audio";

      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.CALL);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void acceptWebRTC(String sessionId) async {
    try {
      QBRTCSession session = await QB.webrtc.accept(sessionId);
      String receivedSessionId = session.id;
      setState(() {
        willNull = acceptPayload();
      });
      // SnackBarUtils.showResult(
      //     _scaffoldKey, "Session with id: $receivedSessionId was accepted");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void rejectWebRTC(String sessionId) async {
    try {
      QBRTCSession session = await QB.webrtc.reject(sessionId);
      setState(() {
        willNull = Container(child: Text("Null"),);
      });
      Navigator.pop(context);
      if(LOGGED_USER_ID != OPPONENT_ID)Flushbar(
        title: "Call ${OPPONENT_ID}",
        message: "Call Rejected By User",
        backgroundColor: Colors.red,
        boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      )..show(context);
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $_sessionId was rejected");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void endWebRTC() async {
    try {
      QBRTCSession session = await QB.webrtc.hangUp(widget.sessionId);
      setState(() {
        willNull = Container(child: Text("Null"),);
      });
      Navigator.pop(context);
      // if(LOGGED_USER_ID != OPPONENT_ID)Flushbar(
      //   title: "Call ${OPPONENT_ID}",
      //   message: "Call Ended",
      //   backgroundColor: Colors.red,
      //   boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      // )..show(context);
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $_sessionId was rejected");
    } on PlatformException catch (e) {
      //DialogUtils.showError(context, e);
      //Navigator.pop(context);
    }
  }


  Future<void> enableVideo(bool enable) async {
    try {
      await subscribeVideoTrack();
      await QB.webrtc.enableVideo(widget.sessionId, enable: enable);

    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> enableAudio(bool enable) async {
    try {
      await QB.webrtc.enableAudio(widget.sessionId, enable: enable);
      //SnackBarUtils.showResult(_scaffoldKey, "The audio was enable $enable");
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

  Future<void> subscribeVideoTrack() async {
    if (_videoTrackSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for:" +
              QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
      return;
    }

    try {
      _videoTrackSubscription = await QB.webrtc
          .subscribeRTCEvent(QBRTCEventTypes.RECEIVED_VIDEO_TRACK, (data) {
        Map<String, Object> payloadMap =
        new Map<String, Object>.from(data["payload"]);

        int opponentId = payloadMap["userId"];

        if (opponentId == LOGGED_USER_ID) {
          startRenderingLocal();
        } else {
          startRenderingRemote(opponentId);
        }
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
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
        setState(() {
          willNull = NotAnswerScreen();
        });
        Flushbar(
          title: "Call",
          message: "Call Rejected By User",
          backgroundColor: Colors.red,
          boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
        )..show(context);
        //DialogUtils.showOneBtn(context, "The user $userId is not answer");
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
        setState(() {
          willNull = RejectScreen();
        });
        setState(() {
          willNull = RejectScreen();
        });
        // DialogUtils.showOneBtn(
        //     context, "The user $userId was rejected your call");
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
        print("I am accepted");
        // setState(() {
        //   willNull = acceptPayload();
        // });
        // SnackBarUtils.showResult(
        //     _scaffoldKey, "The user $userId was accepted your call");
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
        setState(() {
          willNull = HangupScreen();
        });
        //DialogUtils.showOneBtn(context, "the user $userId is hang up");
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
  
  Widget incomingPayload(int id,String messageCallType,String sessionId) => Container(
    height: MediaQuery.of(context).size.height * 0.80,
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("The INCOMING $messageCallType call from user $id"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                acceptWebRTC(sessionId);
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle
                ),
                child: Center(
                  child: Icon(Icons.call_end),
                ),
              ),
            ),
            SizedBox(width: 20.0,),
            GestureDetector(
              onTap: (){
                rejectWebRTC(sessionId);
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle
                ),
                child: Center(
                  child: Icon(Icons.call_end),
                ),
              ),
            )
          ],
        )
      ],
    ),
  );

  Widget acceptPayload() => Stack(
    children: [
      Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.red,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            print("Hello world");
            setState(() {
              isExtraHide = !isExtraHide;
            });
          },
          child: RTCVideoView(
            onVideoViewCreated: _onRemoteVideoViewCreated,
          ),
        ),
      ),
      !isExtraHide ? Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    print("Hello world");
                  },
                  child: Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: RTCVideoView(
                      onVideoViewCreated: _onLocalVideoViewCreated,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Column(
                  children: [
                    if(showTimer == true)runTimer(),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: IconButton(icon: Icon(Icons.call_end,color: Colors.white,),color: Colors.red, onPressed: (){endWebRTC();}),
                      ),
                    )
                  ],
                ),

              ],
            )
          ],
        ),
      ) : Container()
    ],
  );


}


class IncomingCallingScreen extends StatelessWidget {

  int id;
  String messageCallType;
  String sessionId;
  BuildContext context;

  Function accept;
  Function reject;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  IncomingCallingScreen({this.id,this.messageCallType,this.sessionId});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("The INCOMING $messageCallType call from user $id"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  acceptWebRTC();
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(Icons.call_end),
                  ),
                ),
              ),
              SizedBox(width: 20.0,),
              GestureDetector(
                onTap: (){
                  rejectWebRTC();
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(Icons.call_end),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> acceptWebRTC() async {
    try {
      QBRTCSession session = await QB.webrtc.accept(sessionId);
      String receivedSessionId = session.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $receivedSessionId was accepted");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> rejectWebRTC() async {
    try {
      QBRTCSession session = await QB.webrtc.reject(sessionId);
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $sessionId was rejected");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }
}

class HangupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text("Some one hangup")
        ],
      ),
    );
  }
}

class RejectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text("Some one Reject")
        ],
      ),
    );
  }
}

class AcceptScreen extends StatelessWidget {

  RTCVideoViewController localVideoViewController;
  RTCVideoViewController remoteVideoViewController;

  AcceptScreen({this.localVideoViewController,this.remoteVideoViewController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.50,
            child: Text("I am accepted"),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.50,
            child: RTCVideoView(
              onVideoViewCreated: _onRemoteVideoViewCreated,
            ),
          )
        ],
      ),
    );
  }

  void _onLocalVideoViewCreated(RTCVideoViewController controller) {
    localVideoViewController = controller;
  }

  void _onRemoteVideoViewCreated(RTCVideoViewController controller) {
    remoteVideoViewController = controller;
  }
}

class NotAnswerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text("Some one Not Answer")
        ],
      ),
    );
  }
}

