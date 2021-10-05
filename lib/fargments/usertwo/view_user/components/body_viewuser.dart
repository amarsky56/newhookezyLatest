import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userone/Call/components/videocall.dart';
import 'package:hookezy/fargments/usertwo/chat/components/body_chat.dart';
import 'package:hookezy/fargments/usertwo/chat/screen_chat.dart';
import 'package:hookezy/fargments/usertwo/favroite_user/screen_favroite.dart';
import 'package:hookezy/fargments/usertwo/view_user2/screen_user.dart';
import 'package:hookezy/s/chat_master.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/model/recent_chat_model.dart';
import 'package:hookezy/s/model/user_profile_data.dart';
import 'package:hookezy/s/model/view_user_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/p_view.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/s/utils/quick_blox_local.dart';
import 'package:hookezy/s/utils/socket_connector.dart';
import 'package:hookezy/s/utils/stories.dart';
import 'package:ots/ots.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';

import '../../../../constants.dart';

class ViewUserBody extends StatefulWidget {
  int id;

  ViewUserBody({this.id});

  @override
  _ViewUserBodyState createState() => _ViewUserBodyState();
}

class _ViewUserBodyState extends State<ViewUserBody> {
  List<String> widgetList = ['A', 'B', 'C', 'c', 'A', 'B', 'C', 'c', 'r'];

  bool isLoading = true;
  bool isError = false;
  bool isPhotosLoad = false;
  UserProfileData userProfileData;
  Size size;
  double itemHeight;
  double itemWidth;
  bool isAno = false;
  ViewUserModel getUserProfileModel;
  String username;
  String accessToken;

  void getAccessToken() {
    setState(() {
      isAno = true;
    });
    ApiRepository.getAccessToken(getUserProfileModel.name).then((value) {
      setState(() {
        accessToken = value.data["token"];
        isAno = false;
      });
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallPage(
                    channelName: "${getUserProfileModel.name}",
                    accessToken: accessToken,
                    coins: AppConstant.DISCOVER_COINS_PRICE,
                    isVideoEnable: true,
                  )));
    }).catchError((error) {
      setState(() {
        isAno = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUsername();
    fetchUserData();
    fetUserProfile();
    super.initState();
  }

  void getUsername() async {
    SHelper.getUsername().then((value) {
      setState(() {
        username = value;
      });
    }).catchError((error) {});
  }

  void makeCall() {
    print(getUserProfileModel.uuid);
    SHelper.getQuickBloxUserId().then((value) {
      // setState(() {
      //   quId = value;
      // });
      print("Make Call ${value}");
      return QuickBloxLocal.connectChat(value);
    }).then((value) {
      return QuickBloxLocal.initiateFinalCall(
          QBRTCSessionTypes.VIDEO, getUserProfileModel.uuid);
    }).catchError((error) {
      print("Ari mori maiya ${error.toString()}");
    });
  }

  void fetchUserData() {
    ApiRepository.getUserProfileDataOther(widget.id).then((value) {
      setState(() {
        //isLoading = false;
        //isError = false;
        isPhotosLoad = true;
        userProfileData = value;
      });
    }).catchError((error) {
      setState(() {
        //isLoading = false;
        //isError = true;
        isPhotosLoad = true;
        userProfileData = null;
      });
    });
  }

  void fetUserProfile() {
    ApiRepository.getViewUser(widget.id).then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        getUserProfileModel = value;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
        isError = true;
        getUserProfileModel = null;
      });
    });
  }

  void createChatDialog(){
    showLoader(isModal: true);
    QuickBloxLocal.createPrivateChatDialog(getUserProfileModel.uuid).then((value) {
      //print(value);
      hideLoader();
      return Navigator.push(context,
          MaterialPageRoute(builder: (context) => QuickChat(dialogId: value.id,coins: AppConstant.CHAT_MESSAGE_LIST_COINS,displayName: getUserProfileModel.name,))
      ) ;
    });
  }

  void blockCall(String reason) {
    setState(() {
      isAno = true;
    });
    ApiRepository.blockCall(widget.id, reason).then((value) {
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
    ApiRepository.addToFav(widget.id).then((value) {
      setState(() {
        isAno = false;
        getUserProfileModel.isFav =
            getUserProfileModel.isFav == "no" ? "yes" : "no";
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
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 3.5;
    itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: pink,
        title: Text(
          "ViewUser",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                showOptions();
              },
              child: Icon(
                Icons.shield,
                size: 24,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: isLoading == true
          ? ProgressLoader(
              title: "Fetching data",
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewUserScreentwo()));
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.132,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.132,
                                      decoration: BoxDecoration(
                                          color: Color(0xff282A39),
                                          border: Border.all(
                                              width: 1, color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100),
                                          )),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: SNetWorkImage(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.132,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.132,
                                          url: getUserProfileModel
                                              .viewDetails.image,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${getUserProfileModel.name}",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'comfortaa_semibold'),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${getUserProfileModel.viewDetails.country}",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'comfortaa_semibold'),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (getUserProfileModel.uuid !=
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
                                            //return getAccessToken();
                                          },
                                          child: Container(
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(32),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xffEC407A),
                                                    Color(0xffFD6296)
                                                  ],
                                                )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.videocam,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("VideoChat",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'comfortaa_semibold',
                                                        fontSize: 18,
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                createChatDialog();
                                              },
                                              child: Container(
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xffEC407A),
                                                          Color(0xffFD6296)
                                                        ],
                                                      )),
                                                  child: Center(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 15,
                                                          width: 15,
                                                          child: Image.asset(
                                                              "assets/bottomicons/chat.png"),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text("Message",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'comfortaa_semibold',
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                  ))),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(
                                                //     builder: (context) => FavroiteScreen()));
                                                return addFav();
                                              },
                                              child: Container(
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xffEC407A),
                                                        width: 1)),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.favorite,
                                                        size: 15,
                                                        color:
                                                            Colors.pinkAccent,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          getUserProfileModel
                                                                      .isFav ==
                                                                  "no"
                                                              ? "Favorite"
                                                              : "Remove",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'comfortaa_semibold',
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xffEC407A))),
                                                    ],
                                                  ),
                                                )),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("${getUserProfileModel.viewDetails.about}"),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.videocam,
                              size: 32,
                              color: Colors.grey,
                            ),
                            Text(
                              "Stories:",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        userProfileData.stories.isNotEmpty
                            ? UserStories(
                                storyList: userProfileData.stories,
                                showAdd: false,
                              )
                            : Container(
                                height: 80,
                                child: Center(
                                  child: Text("No Stories Available",
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.photo,
                              size: 28,
                              color: Colors.grey,
                            ),
                            Text(
                              "Photos:",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        userProfileData.photos.isNotEmpty
                            ? showGrid()
                            : Container(
                                height: 80,
                                child: Center(
                                  child: Text(
                                    "No Stories Available",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
                isAno == true
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }

  Widget showGrid() {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: userProfileData.photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PView(
                            photos: userProfileData.photos,
                            index: index,
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: new EdgeInsets.all(3.0),
              child: SNetWorkImage(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.50,
                url: userProfileData.photos[index].media,
              ),
            ),
          );
        });
  }

  void showOptions() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 10, color: Colors.grey[900], spreadRadius: 5)
              ],
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Block and Report",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'comfortaa_semibold'),
                        ),
                        Text(
                          "What's the problem?",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'comfortaa_semibold'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: .3,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      return blockCall("Harassment");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 17,
                      color: Colors.pinkAccent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Harassment",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: .3,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      return blockCall("Nudity");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 17,
                      color: Colors.pinkAccent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nudity",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: .3,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      return blockCall("False Gender");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 17,
                      color: Colors.pinkAccent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "False Gender",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: .3,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        });
  }
}
