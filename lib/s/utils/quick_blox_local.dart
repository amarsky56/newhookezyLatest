

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/dialog_utils.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';

class QuickBloxLocal {




  static void init() async {
    try {
      await QB.settings.init(AppConstant.APPLICATION_ID, AppConstant.AUTHORIZATION_KEY, AppConstant.AUTHROIZATION_SECRET, AppConstant.ACCOUNT_KEY,);
    } on PlatformException catch (e) {
      print("quickblox init ${e.toString()}");
      // Some error occurred, look at the exception message for more details
    }
  }

  static void auth() async {
    try {
      String username  = await SHelper.getUsername();
      QBLoginResult result = await QB.auth.login(username, AppConstant.QUICKBLOX_DEFAULT_PASSWORD);
      QBUser qbUser = result.qbUser;
      print("quick ${qbUser.id}");
      QBSession qbSession = result.qbSession;
    } on PlatformException catch (e) { print("quickblox auth ${e.toString()}");
      // Some error occurred, look at the exception message for more details
    }
  }

  static Future<void> initVideoCall() async {
    try {
      await QB.webrtc.init();
      print("hopeless");
    } on PlatformException catch (e) {
      print("init video call ${e}");
      // Some error occurred, look at the exception message for more details
    }
  }


  static Future<void> callWebRTC(int sessionType,int uuid) async {
    try {
      //await QB.webrtc.init();
      QBRTCSession session = await QB.webrtc.call([uuid], sessionType);
      // _sessionId = session.id;
      // SnackBarUtils.showResult(
      //     _scaffoldKey, "The call was initiated for session id: $_sessionId");
    } on PlatformException catch (e) {
      print("callWebRTC Error ${e.toString()}");
      //DialogUtils.showError(context, e);
    }
  }

  static void initiateFinalCall(int sessionType,int uuid){
    initVideoCall();
    callWebRTC(sessionType,uuid);
  }

  // void startReceiveEvent() async {
  //   try{
  //     QBRTCSession session = await QB.webrtc.c;
  //
  //   }on PlatformException catch(e){
  //
  //   }
  // }

  static Future<int> createQuickUser(String username) async {
    String login = "FLUTTER_USER_" + new DateTime.now().millisecond.toString();
    String password = "FlutterPassword";
    try {
      QBUser user = await QB.users.createUser(username,password);
      int userId = user.id;
      return userId;
      print("quickblox reguster ${userId}");
    } on PlatformException catch (e) {
      QBLoginResult user = await QB.auth.login(username,password);
      int userId = user.qbUser.id;
      return userId;
      print("quickbloxxx Login ${userId}");
      //DialogUtils.showError(context, e);
    }
  }

  static void connectChat(int userId) async {
    try {
      await QB.chat.connect(userId, AppConstant.QUICKBLOX_DEFAULT_PASSWORD);
    } on PlatformException catch (e) {
      //DialogUtils.showError(context, e);
    }
  }


  static Future<QBDialog> createPrivateChatDialog(int opponenId) async {

    try {
      QBDialog createdDialog = await QB.chat.createDialog(
          [opponenId],
          "Private Chat",
          dialogType: QBChatDialogTypes.CHAT);
      return createdDialog;
    } on PlatformException catch (e) {
      // some error occurred, look at the exception message for more details
    }
  }



  void disconnectChat() async {
    try {
      await QB.chat.disconnect();
      //SnackBarUtils.showResult(_scaffoldKey, "The chat was disconnected");
    } on PlatformException catch (e) {
      //DialogUtils.showError(context, e);
    }
  }

  static void enableCallConnection(){
    try{
      SHelper.getQuickBloxUserId().then((value) {

        print("Make Call ${value}");
        return QuickBloxLocal.connectChat(value);
      });
    }catch(exceptiom){}
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

  static void initCall(){

  }





}