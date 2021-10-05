import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:bubble/bubble.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/userone/Call/components/videocall.dart';
import 'package:hookezy/fargments/usertwo/chat/components/first_view.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/model/gift_list_model.dart';
import 'package:hookezy/s/model/old_chat_model.dart';
import 'package:hookezy/s/model/recent_chat_model.dart';
import 'package:hookezy/s/model/view_user_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/dialog_utils.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/s/utils/quick_blox_local.dart';
import 'package:hookezy/s/utils/socket_connector.dart';
import 'package:hookezy/screens/purchase_coins/components/body_purchase_coins.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';

import 'second_view.dart';

class BodyChat extends StatefulWidget {

  Item item;
  bool addToFav;
  int coins;
  String dialogId;

  BodyChat({this.item,this.addToFav,this.coins,this.dialogId});

  @override
  _BodyChatState createState() => _BodyChatState();
}

class _BodyChatState extends State<BodyChat> with RouteAware, RouteObserverMixin{
  TextEditingController messageController = TextEditingController();
  int _current = 1;
  String username;
  bool isError = true;
  bool isLoading = false;
  OldChatModel oldChatModel;
  List<OldItem> oldItemChat = [];
  String addToText  = "Add to favourites";
  String unmatchText = "Unmatch";
  String blockandReportText = "Block & Report";
  bool isAno = false;
  GetUserProfileModel getUserProfileModel;
  String userRole;
  GiftListModel giftListModel;
  int userId;
  ViewUserModel viewUserModel;
  String accessToken;
  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
  List<QBMessage> oldmessages;
  int quid;

  StreamSubscription _newMessageSubscription;
  StreamSubscription _systemMessageSubscription;
  StreamSubscription _deliveredMessageSubscription;
  StreamSubscription _readMessageSubscription;
  StreamSubscription _userTypingSubscription;
  StreamSubscription _userStopTypingSubscription;
  StreamSubscription _connectedSubscription;
  StreamSubscription _connectionClosedSubscription;
  StreamSubscription _reconnectionFailedSubscription;
  StreamSubscription _reconnectionSuccessSubscription;

  void getAccessToken(){
    setState(() {
      isAno = true;
    });
    ApiRepository.getAccessToken(widget.item.reciever).then((value) {
      setState(() {
        accessToken = value.data["token"];
        isAno = false;
      });
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallPage(
                channelName: "${widget.item.reciever}",
                accessToken: accessToken,
              )));
    }).catchError((error){
      setState(() {
        isAno = false;
      });
    });
  }



  void loadOldMESSAGE() async {
    setState(() {
      isLoading = true;
    });
    try {
      QB.chat.getDialogMessages(
          widget.dialogId,
          limit: 1000,
          markAsRead: true).then((value) {
            setState(() {
              oldmessages = value;
              isLoading = false;
            });
      });
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false;
      });
      // Some error occurred, look at the exception message for more details
    }
  }

  void makeCall() {
    SHelper.getQuickBloxUserId().then((value) {
      // setState(() {
      //   quId = value;
      // });
      print("Make Call ${value}");
      return QuickBloxLocal.connectChat(value);
    }).then((value) {
      return QuickBloxLocal.initiateFinalCall(
          QBRTCSessionTypes.VIDEO, viewUserModel.uuid);
    }).catchError((error) {
      print("${error.toString()}");
    });
  }

  void fetUserProfileReceiver() {
    ApiRepository.getViewUser(425).then((value) {
      setState(() {
        //isLoading = false;
        //isError = false;
        viewUserModel = value;
        addToText = viewUserModel.isFav == "no" ? "Add to favourites" : "Remove from favourites";
      });
      print("vvvvvvvv ${value.uuid}");
    }).catchError((error) {
      setState(() {
        //isLoading = false;
        //isError = true;
        viewUserModel = null;
      });
    });
  }

  void loadQuickId(){
    SHelper.getQuickBloxUserId().then((value) {
      setState(() {
        quid = value;
      });
    });
  }


  void loadOldChat(){
    setState(() {
      isLoading = true;
    });
    ApiRepository.getOldChat(widget.item.roomId).then((value) {
      setState(() {
        isLoading = false;
        oldItemChat = value.items;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
        oldItemChat = [];
      });
    });
  }

  void loadGift(){
    ApiRepository.getGift(1, userId).then((value) {
      setState(() {
        giftListModel = value;
      });
    }).catchError((error){
      setState(() {
        giftListModel = null;
      });
    });
  }

  void fetUserProfile() {
    ApiRepository.getUserProfile(1).then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        getUserProfileModel = value;
      });
      print("Coinssssss ${getUserProfileModel.coinss}");
    }).catchError((error) {
      setState(() {
        isLoading = false;
        isError = true;
        getUserProfileModel = null;
      });
    });
  }
  
  void loadUserId(){
    SHelper.getUserId().then((value) {
      setState(() {
        userId = int.parse(value);
      });
      fetUserProfile();
      loadGift();
    }).catchError((error){
      
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: Colors.pinkAccent,
        title: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,

              height: 60,
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    height: 45,
                    width: 50,
                    child: Stack(
                      //alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://media4.s-nbcnews.com/j/newscms/2019_01/2705191/nbc-social-default_b6fa4fef0d31ca7e8bc7ff6d117ca9f4.nbcnews-fp-1200-630.png"),
                                fit: BoxFit.fill),
                          ),

                        ),
                        Positioned(
                          top: 28,
                          left: 36,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello",
                        //"${widget.item.nameOne == username ? widget.item.nameTwo : widget.item.nameOne}",
                        style: TextStyle(
                            fontSize: 16
                        ),),
                      Text("Online",
                        style: TextStyle(
                            fontSize: 12
                        ),)
                    ],
                  )

                ],
              ),
            ),

          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.phone,
              color:Colors.white), onPressed: (){
            if (viewUserModel.uuid !=
                null) {
              makeCall();
            } else {
              Flushbar(
                title: "Call",
                backgroundColor: Colors.red,
                message: "Unable to get UUID",
                flushbarPosition:
                FlushbarPosition.TOP,
                duration: Duration(seconds: 3),
              )..show(context);
            }
          }),
          PopupMenuButton<String>(
            onSelected: (String value){
              print(value);
              if(value == "Add to favourites"){
                return widget.item.userId != 1 ? addFav() : SHelper.showFlushBar("Chat", "Unable to proceeed", context);
              }else if(value == "Block & Report"){
                //return blockCall();
                return widget.item.userId != 1 ? blockCall() : SHelper.showFlushBar("Chat", "Unable to proceeed", context);
              }
            },
            itemBuilder: (BuildContext context) {
              return {
                addToText,
                unmatchText,
                blockandReportText,/* 'Settings'*/}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: isLoading == true ? ProgressLoader(title: "Fetching Data...",) : Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    child: ListView.builder(
                        itemCount: oldmessages.length + 1,
                        itemBuilder: (context,index){
                          return index == 0 ? showEndToEnd() : bubbleQB(oldmessages[index - 1]);
                        }),

                  ),
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      //color:  Color(0xff2D2F36),
                      boxShadow: [ BoxShadow(
                        color: Colors.black,
                        blurRadius: 20.0,
                      ),]
                  ),
                  //height: MediaQuery.of(context).size.height*0.12,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 2,right: 2,top: 2,bottom: 2),
                        child: Container(
                          decoration: BoxDecoration(
                              //color:  Color(0xff2D2F36),
                              //shape: BoxShape.circle,
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              boxShadow: [ BoxShadow(
                                color: Colors.black,
                                blurRadius: 20.0,
                              ),]
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                flex: 14,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.pinkAccent,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(6),
                                    child: InkWell(
                                      onTap: (){
/*                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: MediaQuery.of(context).viewInsets,
                                              child: DefaultTabController(
                                                length: 2,
                                                initialIndex: 0,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    TabBar(
                                                      labelColor: Colors.red,
                                                      tabs: <Widget>[
                                                        Tab(
                                                          icon: Icon(Icons.edit),
                                                        ),
                                                        Tab(
                                                          icon: Icon(Icons.note_add),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      height:
                                                      100,     //I want to use dynamic height instead of fixed height
                                                      child: TabBarView(
                                                        children: <Widget>[
                                                          Column(
                                                            children: <Widget>[
                                                              TextField(
                                                                decoration:
                                                                InputDecoration(hintText: 'Enter Task'),
                                                              ),
                                                              RaisedButton(
                                                                child: Text('Submit'),
                                                                onPressed: () {},
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            children: <Widget>[
                                                              TextField(
                                                                decoration:
                                                                InputDecoration(hintText: 'Personal Note'),
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {},
                                                                child: Text('Submit'),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });*/
                                        showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 10,
                                                        color: Colors.white,
                                                        spreadRadius: 5)
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(15)),
                                                ),
                                                height: size.height / 3,
                                                width: size.width - 20,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                        child:Container(
                                                          child:GridView.builder(
                                                            physics: ScrollPhysics(),

                                                            itemBuilder: (context, position) {
                                                              return Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      top: 14.0,left: 4,right: 4),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: <Widget>[
                                                                        // Container(
                                                                        // //color: Colors.green,
                                                                        // width: 100,
                                                                        // decoration: BoxDecoration(
                                                                        //     shape: BoxShape.circle,
                                                                        //     image: DecorationImage(
                                                                        //       image: NetworkImage(giftListModel.giftData[position].image,),
                                                                        //     )
                                                                        // ),
                                                                        // height: 80,),
                                                                        SizedBox(
                                                                          height: 80,
                                                                          width: 100,
                                                                          child: GestureDetector(
                                                                            onTap: (){
                                                                              Navigator.pop(context);
                                                                              sendMessageGift(giftListModel.giftData[position].coins, giftListModel.giftData[position].image);
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  image: DecorationImage(
                                                                                    image: NetworkImage(giftListModel.giftData[position].image,),
                                                                                  )
                                                                              ),
                                                                              height: 80,
                                                                              width: 100,
                                                                              //width: size.width/5,
                                                                              //child:
                                                                              // Image
                                                                              //     .network(
                                                                              //   '${giftListModel.giftData[position].image}',
                                                                              //   fit: BoxFit
                                                                              //       .cover,
                                                                              // )

                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height:30,
                                                                              width: 30,
                                                                              child: Image.asset(
                                                                                  "assets/images/coin.png"
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "${giftListModel.giftData[position].coins}",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                              );},
                                                            itemCount: giftListModel != null ? giftListModel.giftData.length : 0,
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 4,
                                                              //childAspectRatio: 0.5
                                                              childAspectRatio: (MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width / 9.5 / 60),
                                                            ),
                                                          ),
                                                        ) /*Container(
                                                    child:   DefaultTabController(
                                                      length: 2,
                                                      initialIndex: 0,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Container(
                                                              //I want to use dynamic height instead of fixed height
                                                              child: TabBarView(
                                                                children: <Widget>[
                                                                  Column(
                                                                    children: <Widget>[
                                                                      TextField(
                                                                        decoration:
                                                                        InputDecoration(hintText: 'Enter Task'),
                                                                      ),
                                                                      RaisedButton(
                                                                        child: Text('Submit'),
                                                                        onPressed: () {},
                                                                      )
                                                                    ],
                                                                  ),

                                                                  Container(
                                                                    child: GridView.builder(
                                                                      physics: ScrollPhysics(),

                                                                      itemBuilder: (context, position) {
                                                                        return Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 14.0,left: 4,right: 4),
                                                                            child: Container(
                                                                              width: 10,
                                                                              height: 100,
                                                                              color: Colors.red,
                                                                              */
                                                      /*child:Column(
                                                                                children: <Widget>[
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        100),
                                                                                    child: Container(
                                                                                        height: 22.0,
                                                                                        width: 22.0,
                                                                                        child:
                                                                                        FittedBox(
                                                                                          fit: BoxFit.fill,
                                                                                          child: Image
                                                                                              .asset(
                                                                                            'assets/images/girl.png',
                                                                                            fit: BoxFit
                                                                                                .fill,
                                                                                          ),
                                                                                        )

                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    "67",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black,
                                                                                        fontSize: 8.0),)
                                                                                ],
                                                                              ),*//*
                                                                            )
                                                                        );},
                                                                      itemCount: 9,
                                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount: 3,
                                                                        childAspectRatio: (MediaQuery
                                                                            .of(context)
                                                                            .size
                                                                            .width / 5.5 / 60),),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          TabBar(
                                                            labelColor: Colors.pink,
                                                            indicatorColor:Colors.yellow,
                                                            indicatorWeight:5,
                                                            tabs: <Widget>[
                                                              Tab(
                                                                icon: Icon(Icons.person),
                                                              ),
                                                              Tab(
                                                                icon: Icon(Icons.note_add),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )                                                                            ,
                                                  )
*/                                                  ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: size.width/3,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            color: kPrimaryColor,
                                                            //borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text("My Coins",style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                              ),),
                                                              SizedBox(width: 6,),
                                                              Container(
                                                                  height:23,
                                                                  width:23,
                                                                  child: Image.asset("assets/images/coin.png")),
                                                              SizedBox(width: 10,),
                                                              Text("${getUserProfileModel.coinss}",style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                              ),)
                                                            ],
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: (){
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (context)=>PurchaseCoinsBody(getUserProfileModel: getUserProfileModel,)));
                                                          },
                                                          child: Container(
                                                            width: size.width/3,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              color: pink,
                                                              //borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                    height:23,
                                                                    width:23,
                                                                    child: Image.asset("assets/images/coin.png")),
                                                                SizedBox(width: 6,),
                                                                Text("Purchase",style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                ),)
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,

                                        child: Container(
                                            height:8,
                                            width:8,
                                            child: Icon(Icons.card_giftcard,
                                              color: Colors.white,)
                                        ),
                                      ),
                                    ),
                                  ),
                                  //color: Colors.white,
                                ),
                              ),
                              Expanded(
                                flex: 82,
                                child: Container(
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(

                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: TextFormField(
                                              maxLines: null,
                                              controller: messageController,
                                              style: TextStyle(color: Colors.white),
                                              decoration:
                                              new InputDecoration.collapsed(
                                                hintText: 'Send message...',
                                                hintStyle: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: 'comfortaa_semibold',
                                                    color: Colors.white),
                                              ),
                                              //controller: passwordController,
                                              //focusNode: _password,
                                              // style: TextStyle(color: Color(0xff7AD530)),
                                              keyboardType: TextInputType.text,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 12,
                                child: Container(

                                  child: Padding(
                                    padding: EdgeInsets.all(6),
                                    child: InkWell(
                                      onTap: (){

                                      },
                                      child: Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,

                                        child: Container(
                                            height:10,
                                            width:10,
                                            child: Icon(Icons.image,
                                              color: Colors.white,)
                                        ),
                                      ),
                                    ),
                                  ),
                                  //color: Colors.white,
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(6),
                                    child: InkWell(
                                      onTap: () async {
                                        //Check if the textfield has text or not
                                        if (messageController.text.isNotEmpty) {
                                          //sendMessage();
                                          try {
                                            await QB.chat.sendMessage(
                                                widget.dialogId,
                                                body: messageController.text,

                                                saveToHistory: true);
                                          } on PlatformException catch (e) {
                                            print("Unable to sent messagesss ${widget.dialogId}");
                                            // Some error occurred, look at the exception message for more details
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color:  Color(0xff2d2f36),
                                            shape: BoxShape.circle,
                                            //borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                            boxShadow: [ BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 20.0,
                                            ),]
                                        ),
                                        child: Container(
                                            height:10,
                                            width:10,
                                            child: Center(
                                              child: Icon(Icons.send,
                                                color: Colors.white,),
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                  //color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  ),
                  //color: Color(0xff2D2F36),
                ),
              ],

            ),
          ),
          isAno == true ? Container(child: Center(child: CircularProgressIndicator(),),) : Container()
        ],
      ),
    );
  }

  void subscribeNewMessage() async {
    if (_newMessageSubscription != null) {

      return;
    }
    try {
      _newMessageSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE, (data) {
        Map<dynamic, dynamic> map = new Map<dynamic, dynamic>.from(data);

        Map<dynamic, dynamic> payload =
        new Map<dynamic, dynamic>.from(map["payload"]);
        //_messageId = payload["id"] as String;


      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });

    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }


  Widget bubble(OldItem model) => Bubble(
    margin: BubbleEdges.only(top: 10),
    alignment: model.fromMsg == username ?  Alignment.topRight : Alignment.topLeft,
    nip: model.fromMsg == username ? BubbleNip.rightTop : BubbleNip.leftTop,
    color: model.fromMsg == username ? Color.fromRGBO(225, 255, 199, 1.0) : Colors.grey.withOpacity(0.70),
    child: model.msg.startsWith("http") ? imageContainer(model.msg) : Text('${model.msg} - ${model.fromMsg}',style: TextStyle(fontSize: 20) ,textAlign: model.fromMsg == username ? TextAlign.left : TextAlign.right),
  );

  Widget bubbleQB(QBMessage model) => Bubble(
    margin: BubbleEdges.only(top: 10),
    alignment: model.senderId == username ?  Alignment.topRight : Alignment.topLeft,
    nip: model.senderId == username ? BubbleNip.rightTop : BubbleNip.leftTop,
    color: model.senderId == username ? Color.fromRGBO(225, 255, 199, 1.0) : Colors.grey.withOpacity(0.70),
    child: model.body.startsWith("http") ? imageContainer(model.body) : Text('${model.body}',style: TextStyle(fontSize: 20) ,textAlign: model.senderId == username ? TextAlign.left : TextAlign.right),
  );

  Widget imageContainer(String url) => Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: NetworkImage(url)
      )
    ),
  );



  void _onRecieveRoomId(dynamic message){
    print("Room Id is ${message}");
  }


  void onReceiveChatMessage(dynamic message){
    SHelper.showFlushBar("H", "${message}", context);
    print("Simple ${message}");
    var v = json.decode(message);
    setState(() {
      oldItemChat.add(OldItem(msg: v["msg"],fromMsg: v["msgFrom"] != null ? v["msgFrom"] : username,toMsg: username));
    });
  }

  Widget showEndToEnd() => Container(
    //height: 20,
    margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.lock,size: 12,),
        Expanded(child: Text("Messages are end-to-end encrypted. No One outside of this chat can read or listen to them",textAlign: TextAlign.center,))
      ],
    ),
  );
  
  void sendMessage(){
    if(messageController.text != null){
      print(getUserProfileModel.coinss > widget.coins);
      if(getUserProfileModel.coinss > widget.coins){
        ChatConnector.sendMessage(messageController.text, widget.item.sender,username, DateTime.now().toString().substring(0,10), widget.item.reciever, onReceiveChatMessage);
        //deductCoins(20);
        setState(() {
          messageController.text = null;
        });
      }else{
        SHelper.showFlushBar("Coins", "You Don't have Enough Coins to send message", context);
      }
    }
  }

  void sendMessageGift(int coins,String url){
    if(messageController.text != null){
      if(getUserProfileModel.coinss > widget.coins){
        ChatConnector.sendMessage(url, widget.item.sender,username, DateTime.now().toString().substring(0,10), widget.item.reciever, onReceiveChatMessage);
        deductCoins(coins);
        setState(() {
          messageController.text = null;
        });
      }else{
        SHelper.showFlushBar("Coins", "You Dont have Enough Coins to send message", context);
      }
    }
  }


  void loadUserRole(){
    SHelper.returnUserRole().then((value) {
      setState(() {
        userRole = value;
      });
    });
  }
  
  void deductCoins(int coins){
    ApiRepository.deductCoins(widget.coins,"425").then((value) {
      setState(() {
        getUserProfileModel.coinss = getUserProfileModel.coinss - widget.coins;
      });
    }).catchError((error){
      
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //getUsername();
    loadQuickId();
    loadUserId();
    fetUserProfileReceiver();
    loadUserRole();
    //loadOldChat();
    loadOldMESSAGE();
    //print("vvvvvvvvv ${viewUserModel.viewDetails.language}");
    //ChatConnector.setRoom(widget.item.nameOne, widget.item.nameTwo);
    //ChatConnector.setUserData(username);
    //ChatConnector.subscribeService(ChatConnector.SET_ROOM_KEY, _onRecieveRoomId);
    //ChatConnector.subscribeService(ChatConnector.SEND_RECEIVE_MESSAGE, onReceiveChatMessage);

    super.initState();
  }

  void getUsername() async{
    SHelper.getUsername().then((value) {
      setState(() {
        username = value;
      });
    }).catchError((error){

    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Add to Favorites':
       // hitBlockUserApi();
        break;
    case 'Unmatch':

        break;
      case 'Block and Report':
        break;
    }
  }

  void blockCall() {
    setState(() {
      isAno = true;
    });
    ApiRepository.reportUser(widget.item.userId,"n").then((value) {
      setState(() {
        isAno = false;
      });

      Navigator.pop(context);
      SHelper.showFlushBar("Block", "User blocked", context);
    }).catchError((error) {
      SHelper.showFlushBar("Block", "${error.toString()}", context);
      setState(() {
        isAno = false;
      });
    });
  }

  void addFav() {
    setState(() {
      isAno = true;
    });
    ApiRepository.addToFav(widget.item.userId).then((value) {
      setState(() {
        isAno = false;
        addToText = addToText == "Add to favourites" ? "Add to favourites" : "Remove from favourites";
        widget.addToFav == false ? "yes" : "no";
      });
      SHelper.showFlushBar("Favourite", "Add to Favourite", context);
      //Navigator.pop(context);
    }).catchError((error) {
      setState(() {
        isAno = false;
      });
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
    print("i am da");
    //ChatConnector.setRoom(widget.item.nameOne, widget.item.nameTwo);
    //ChatConnector.setUserData(username);
    //ChatConnector.subscribeService(ChatConnector.SET_ROOM_KEY, _onRecieveRoomId);
    //ChatConnector.subscribeService(ChatConnector.SEND_RECEIVE_MESSAGE, onReceiveChatMessage);
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


