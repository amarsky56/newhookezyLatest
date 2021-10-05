import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/userone/Call/screen_call.dart';
import 'package:hookezy/fargments/userone/message/components/body_message_userone.dart';
import 'package:hookezy/fargments/userone/message/screen_messages_userone.dart';
import 'package:hookezy/fargments/userone/profile/screen_profile_userone.dart';
import 'package:hookezy/fargments/userthree/leader/components/body_leader_userthree.dart';
import 'package:hookezy/fargments/usertwo/discover/components/body_discover_fragment.dart';
import 'package:hookezy/fargments/usertwo/discover/screen_discover_fragment.dart';
import 'package:hookezy/quickblox_video.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/model/random_user_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/dialog_utils.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/s/utils/quick_blox_local.dart';
import 'package:hookezy/s/utils/snackbar_utils.dart';
import 'package:hookezy/s/utils/socket_connector.dart';
import 'package:ots/ots.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeBody extends StatefulWidget {
  static int currentindex =0 ;

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> with RouteAware, RouteObserverMixin{
  String isPremium;
  bool validValue = false;
  bool isLoad = true;
  SharedPreferences sharedPreferences;
  GetUserProfileModel getUserProfileModel;
  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _sessionId;

  RTCVideoViewController _localVideoViewController;
  RTCVideoViewController _remoteVideoViewController;

  bool _videoCall = true;
  int LOGGED_USER_ID;

  StreamSubscription _callSubscription;
  StreamSubscription _callEndSubscription;
  StreamSubscription _rejectSubscription;
  StreamSubscription _acceptSubscription;
  StreamSubscription _hangUpSubscription;
  StreamSubscription _videoTrackSubscription;
  StreamSubscription _notAnswerSubscription;
  StreamSubscription _peerConnectionSubscription;
  StreamSubscription _newMessageSubscription;

  Stopwatch watch = Stopwatch();
  Timer timer;
  bool startStop = true;
  String elapsedTime = '';
  String totalMinutes = '1';

  RandomUserModel randomUserModel;

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
        totalMinutes = getMinutes(watch.elapsedMilliseconds);
      });
      print("Time Left: ${elapsedTime}");
    }
  }

  void getRandomUser(){
    ApiRepository.getRandomUser().then((value) {
      setState(() {
        randomUserModel = value;
      });
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  getMinutes(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');

    return "$minutesStr";
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      startStop = true;
      watch.stop();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  void subscribeNewMessage() async {
    if (_newMessageSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.RECEIVED_NEW_MESSAGE);
      return;
    }
    try {
      _newMessageSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE, (data) {
        Map<dynamic, dynamic> map = new Map<dynamic, dynamic>.from(data);

        Map<dynamic, dynamic> payload =
        new Map<dynamic, dynamic>.from(map["payload"]);
        String _messageId = payload["body"] as String;
        //print("Receiveed Message ${map}");
        SHelper.showFlushBar("New Message", "${_messageId}", context);
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      // SnackBarUtils.showResult(
      //     _scaffoldKey, "Subscribed: " + QBChatEvents.RECEIVED_NEW_MESSAGE);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeNewMessage() {
    // if (_newMessageSubscription != null) {
    _newMessageSubscription.cancel();
    // _newMessageSubscription = null;
    SnackBarUtils.showResult(
        _scaffoldKey, "Unsubscribed: " + QBChatEvents.RECEIVED_NEW_MESSAGE);
    /*} else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBChatEvents.RECEIVED_NEW_MESSAGE);
    }*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("i am general body dispose");
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


  final tabs =[
    CallScreenFragment(),
    //DiscoverScreenFragment(),
    UseroneMessageBody(),
    ScreenUseroneProfile()
  ];

  final tabsPremium =[
    CallScreenFragment(),
    DiscoverFragmentBody(),
    UseroneMessageBody(),
    ScreenUseroneProfile()
  ];

  final tabsHost =[
    CallScreenFragment(),
    UseroneMessageBody(),
    LeaderBodyUserthree(),
    ScreenUseroneProfile()
  ];

  Flushbar flush;


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
    )) ?? false;
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchProfile();
    getRandomUser();
    startQuick();
    startQuickMain();

    ChatConnector.connectorSocket();
    //ChatConnector.unsubscribeService();
    super.initState();
  }

  void startQuickMain(){
    QuickBloxLocal.init();
    QuickBloxLocal.auth();
    SHelper.getQuickBloxUserId().then((value) {
      return QuickBloxLocal.connectChat(value);
    }).then((value) {
      print("Hollllll");
      subscribeQuick();
    });
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
    subscribeNewMessage();
  }

  void isConnected() async {
    try {
      bool connected = await QB.chat.isConnected();
      SnackBarUtils.showResult(
          _scaffoldKey, "The Chat connected: " + connected.toString());
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuickVideo(sessionId: session.id,)));
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
        hideLoader();
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
        hideLoader();
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
        print("was accepted your call ${data}");
        // SnackBarUtils.showResult(
        //     _scaffoldKey, "The user $userId was accepted your call");
        //DialogUtils.showError(context, data);
        //startWatch();
        hideLoader();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuickVideo(sessionId: data["payload"]["session"]["id"],)));
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
        print("Hangupssss ${data}");
        int userId = data["payload"]["userId"];
        Navigator.pop(context);
        //stopWatch();
        //deductCoins(1);
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

  void deductCoins(int coins){
    ApiRepository.deductCoins(int.parse(totalMinutes),randomUserModel.id.toString()).then((value) {
      setState(() {
        getUserProfileModel.coinss = getUserProfileModel.coinss -  coins;
        //coindLess = getUserProfileModel.coinss < widget.coins;
      });
      //print("65675757 ${getUserProfileModel.coinss} ${widget.coins} ${getUserProfileModel.coinss < widget.coins}");
      //if(coindLess)_engine.destroy();
      //coindLess == true ? showDialog(context: context, barrierDismissible:false,builder: (BuildContext context) => erroDialog()) : null;
      //if(_engine != null )_engine.enableAudio();
      //print("tyrtrtrt ${getUserProfileModel.coinss}");
      //deductCoins(preserveLast);
      //Navigator.pop(context);
      print("deduction happen  ${value}");
    }).catchError((error){

    });
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


  Future<bool> saveRole(String role,String username) async {
    print(role);
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("userRole", role);
    //await sharedPreferences.setString("userName", username);
    await sharedPreferences.setBool("isHost", role == "Host" ? true : false);
    return true;
  }

  void fetchProfile(){
    setState(() {
      isLoad = true;
    });
    ApiRepository.getUserProfile(1).then((value) {
      setState(() {
        getUserProfileModel = value;
      });
      print("i am prrrr ");
      return saveRole(value.role,value.name);
    }).then((value) {

      return SHelper.returnUserRole();
    }).then((value) {
      print("Simmmm ${value}");
      setState(() {
        isLoad = false;
        isPremium = value;
      });
    }).catchError((error){
      print(error.toString());
      setState(() {
        isLoad = false;
        isPremium = null;
      });
    });

  }

  void setPremium(){
    setState(() {
      isLoad = true;
    });
    SHelper.returnUserRole().then((value) {
      print("mint ${value}");
      setState(() {
        isLoad = false;
        isPremium = value;
      });
    }).catchError((error){
      setState(() {
        isLoad = false;
        isPremium = null;
      });
    });
  }

  void startQuick(){
    SHelper.getQuickBloxUserId().then((value) {
      // setState(() {
      //   quId = value;
      // });
      print("Make Call ${value}");
      return QuickBloxLocal.connectChat(value);
    }).then((value) {
      print("Hola i am running quickblox");
      return QuickBloxLocal.initVideoCall();
    }).catchError((error){
      print("Ari mori maiya ${error.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    //QuickBloxLocal.initVideoCall().then((value) {});
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              //unselectedItemColor: Colors.white,
/*            showSelectedLabels: false,   // <-- HERE
              showUnselectedLabels: false,*/
              backgroundColor: Color(0xffFFFCFC),
              items:  <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("assets/bottomicons/call.png"),),
                  title: Text('Call'),
                ),
                if(isPremium == "Premium")BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("assets/bottomicons/discover.png"),),
                  title: Text('Discover'),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("assets/bottomicons/chat.png"),),
                  title: Text('Messages'),
                ),
                if(isPremium == "Host")BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("assets/bottomicons/leaderboard.png"),),
                  title: Text('Leaders'),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("assets/bottomicons/profile.png"),),
                  title: Text('Profile'),
                ),

              ],
              currentIndex: HomeBody.currentindex,
              selectedItemColor: pink,
              /* currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,*/
              onTap: (index) {
                //Handle button tap
                setState(() {
                  HomeBody.currentindex = index;
                });
              }
          ),
          body: uipayload()
      ),
    ) ;
  }

  Widget uipayload(){
    if(isPremium == "Host"){
      return tabsHost[HomeBody.currentindex];
    }else if(isPremium == "Premium"){
      return tabsPremium[HomeBody.currentindex];
    }else {
      return tabs[HomeBody.currentindex];
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
    print("i am da");
    fetchProfile();
    startQuickMain();
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
