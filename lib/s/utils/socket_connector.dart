

import 'dart:convert';

import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class ChatConnector {

  static SocketIO socketIO;

  static final String SET_ROOM_KEY = "set-room";

  static final String SET_USER_DATA = "set-user-data";

  static final String SEND_RECEIVE_MESSAGE = "chat-msg";

  static final String TYPING_KEY = "typing";

  static void connectorSocket(){
    // http://13.127.44.197:4600
    socketIO = SocketIOManager().createSocketIO("http://13.127.44.197:4600","/");
    socketIO.init();
    socketIO.connect();
  }



  static void setRoom(String nameOne,String nameTwo){
    var v = json.encode({"name1":"${nameOne}-${nameTwo}","name2":"${nameTwo}-${nameOne}","sender":"${nameOne}","receiver":"${nameTwo}"});
    print(v);
    socketIO.sendMessage(SET_ROOM_KEY, v);
  }

  static void setUserData(String username){
    socketIO.sendMessage(SET_USER_DATA, json.encode({"userName":username}));
  }

  static subscribeService(String eventName,Function callback){
    socketIO.subscribe(eventName, callback);
  }

  static unsubscribeService(){
    socketIO.unSubscribesAll();
  }

  static sendMessage(String message,String msgTo,String nameOne,String date,String receiver,Function callBack) async {
    socketIO.sendMessage(SEND_RECEIVE_MESSAGE, json.encode({"msg":message,"msgTo":msgTo,"date":date,"receiver":receiver}));
  }

}