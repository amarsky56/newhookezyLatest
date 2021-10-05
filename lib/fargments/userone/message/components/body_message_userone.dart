import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/usertwo/chat/components/body_chat.dart';
import 'package:hookezy/fargments/usertwo/chat/screen_chat.dart';
import 'package:hookezy/fargments/usertwo/view_user/screen_viewuser.dart';
import 'package:hookezy/s/chat_master.dart';
import 'package:hookezy/s/fav_list_ui.dart';
import 'package:hookezy/s/model/recent_chat_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/dialog_utils.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/s/utils/quick_blox_local.dart';
import 'package:hookezy/s/utils/snackbar_utils.dart';
import 'package:hookezy/s/utils/socket_connector.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class UseroneMessageBody extends StatefulWidget {
  @override
  _UseroneMessageBodyState createState() => _UseroneMessageBodyState();
}

class _UseroneMessageBodyState extends State<UseroneMessageBody> {

  bool isError = false;
  bool isLoading = true;
  Size size;
  SocketIO socketIO;
  String username;
  bool isSearchEnable = false;
  List<QBDialog> chatDialogs = [];


  RecentChatModel recentChatModel,filterModel;

  void fetchChat(){
    setState(() {
      isError = false;
      isLoading = true;

    });
    ApiRepository.getRecentChat().then((value) {
      setState(() {
        isError = false;
        isLoading = false;
        recentChatModel = value;
        filterModel = value;
      });
    }).catchError((error){
      setState(() {
        isError = true;
        isLoading = false;

      });
    });
  }

  void connectorSocket(){
    socketIO = SocketIOManager().createSocketIO("http://13.127.44.197:4600", "/");
    socketIO.init();
    socketIO.connect();

  }


  void sendMessage(){
    //ChatConnector.sendMessage("Hello world", "ssa", DateTime.now().toString().substring(0,10), "ss",_onReceiveChatMessage);
  }

  @override
  void initState() {
    // TODO: implement initState
    getUsername();
    //createDialog();
    //fetchChat();
    getDialogs();
    //ChatConnector.subscribeService(ChatConnector.SET_ROOM_KEY, _onRecieveRoomId);
    //ChatConnector.subscribeService(ChatConnector.SEND_RECEIVE_MESSAGE, _onReceiveChatMessage);
    //ChatConnector.setUserData(username);

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

  void getDialogs() async {
    setState(() {
      isLoading = true;
    });
    try {
      QBSort sort = QBSort();
      sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
      sort.ascending = true;

      QBFilter filter = QBFilter();
      //filter.field = QBChatDialogFilterFields.ID;
      filter.field = QBChatDialogFilterFields.LAST_MESSAGE_DATE_SENT;
      filter.operator = QBChatDialogFilterOperators.ALL;
      filter.value = "";

      QB.chat.getDialogs().then((value) {
        setState(() {
          chatDialogs = value;
          isLoading = false;
        });
      });
      var dialogsLength = chatDialogs.length;
      print("QuickBlox Length 1565766576 ${dialogsLength}");
      // SnackBarUtils.showResult(
      //     _scaffoldKey, "The $dialogsLength dialogs were loaded success");
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false;
      });
      DialogUtils.showError(context, e);
    }
  }




  void createDialog(){
    SHelper.getQuickBloxUserId().then((value) {
      return QuickBloxLocal.createPrivateChatDialog(128688775);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ChatConnector.unsubscribeService();
    super.dispose();
  }

  void _onRecieveRoomId(dynamic message){
    print("Room Id is ${message}");
  }


  void _onReceiveChatMessage(Object message){
    print("Simple ${message}");


  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: pink,
        leading: IconButton(onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>FavList()));
        },icon: Icon(Icons.people,size: 20,),),
        title: Text("Message",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
        actions: [

          IconButton(icon: Icon(isSearchEnable ? Icons.close : Icons.search), onPressed: (){
            //ChatConnector.unsubscribeService();

            setState(() {
              isSearchEnable = !isSearchEnable;
            });
          })
        ],
      ),
      body: uiPayload(),
    );
  }

  Widget _showNoData(String data) => Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Center(
      child: Text(data,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
    ),
  );

  Widget uiPayload(){
    if(isError){
      return ErrorScreen(onRefresh: (){return fetchChat();},);
    }else if(isLoading){
      return ProgressLoader(title: "Fetching Chats...",);
    }else{
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isSearchEnable)Container(
              margin: EdgeInsets.only(left: 10.0,right: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search"
                ),
                onChanged: (value){
                  setState(() {
                    filterModel.items.where((element) => element.reciever == value.toLowerCase()).toList();
                  });
                },
              ),
            ),
            Text("CONVERSATION HISTORY",
              style: TextStyle(
                  color: Color(0xffEC407A),
                  fontSize: 16
              ),),
            SizedBox(
              height: 8,
            ),
            Container(
              width: size.width,
              height: size.height/5,
              child: true ? _showNoData("no conversation history") :  ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,position){
                  return Padding(
                      padding: const EdgeInsets.only(right: 18.0,),
                      child: Stack(
                        children: [
                          Container(
                            width:size.width/3.1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black),
                                borderRadius:
                                BorderRadius.circular(8.0),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLUU4RH0MQoXrtxXHncCFi3H6S9saN_i49lQ&usqp=CAU")
                                )

                            ),
                            margin: new EdgeInsets.all(0.0),

                          ),
                          Positioned(
                            bottom: 1,
                            left: 1,
                            right: 1,
                            child: Container(
                              width: size.width/3.1,
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  color: Colors.grey
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left:10.0),
                                child: Text("Username",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),),
                              ),
                            ),
                          )
                        ],
                      )
                  );
                },
                itemCount: 4,),
            ),
            SizedBox(height: 10,),
            Text("MESSAGES",
              style: TextStyle(
                  color: Color(0xffEC407A),
                  fontSize: 16
              ),),
            SizedBox(
              height: 8,
            ),
            Expanded(
                child: Container(
                  child: chatDialogs.isEmpty ?  _showNoData("no messages till now"):  ListView.builder(
                    itemBuilder: (context, positon) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async{
                              //sentChat(chatDialogs[positon].id);
                              //ChatConnector.setRoom(filterModel.items[positon].nameOne, filterModel.items[positon].nameTwo);
                              //ChatConnector.setRoom(username, recentChatModel.items[positon].sender == username ? recentChatModel.items[positon].sender : recentChatModel.items[positon].reciever);
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => BodyChat(dialogId: chatDialogs[positon].id,coins: AppConstant.CHAT_MESSAGE_LIST_COINS,))
                              // ) ;

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => QuickChat(dialogId: chatDialogs[positon].id,coins: AppConstant.CHAT_MESSAGE_LIST_COINS,displayName: chatDialogs[positon].name,))
                              ) ;
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(6),),
                                  color: Color(0xffe5e5e5)
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                child: Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [

                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                                color: Color(0xff282A39),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        "${chatDialogs[positon].photo}"))
                                              //color: Colors.red,
                                            ),
                                            height: 50,
                                            width: 50,
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${chatDialogs[positon].name}",
                                                //"${filterModel.items[positon].sender == username ? filterModel.items[positon].reciever : filterModel.items[positon].sender}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "${chatDialogs[positon].lastMessage.startsWith("http") ? "Gift" : chatDialogs[positon].lastMessage}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff999999)
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                            color: kPrimaryColor
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          )
                        ],
                      );
                    },
                    itemCount: chatDialogs.length,
                  ),
                )
            )
          ],
        ),
      );
    }
  }
}
