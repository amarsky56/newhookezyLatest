import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookezy/main.dart';
import 'package:hookezy/model/screens/register_api.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/quick_blox_local.dart';
import 'package:hookezy/screens/discover/discover_screen.dart';
import 'package:hookezy/screens/final_step/components/background_final_step.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hookezy/screens/general/general_screen.dart';
import 'package:hookezy/screens/searching/searching_screen.dart';
import 'package:ots/ots.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert' as JSON;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class FinalStepBody extends StatefulWidget {
  String name, gender;

  FinalStepBody({this.name, this.gender});

  @override
  _FinalStepBodyState createState() => _FinalStepBodyState();
}

class _FinalStepBodyState extends State<FinalStepBody> {
  PermissionStatus _permissionStatus;

  String _selectedId;
  static int selectedRadioTile;
  String gender;

  SharedPreferences prefs;
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
      if(selectedRadioTile == 1){
        gender = "Female";
        print("fffffffffffffff");
      }
      else if(selectedRadioTile == 2){
        gender = "Male";
        print("mmmmmmmmmmmmmmmm");
      }
      else{
        gender = "Both";
        print("bbbbbbbbbbbbbbbbbbbb");
      }
    });
  }
  bool is_user_login = false;
  bool call = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FinalStepBackground(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: !call
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.09,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserTwo()));
                          },
                          child: Container(
                            height: size.height * 0.12,
                            width: size.height * 0.12,
                            child: Image.asset("assets/images/warningsign.png"),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Text(
                          "Final Step",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Text(
                            "Enable microphone and camera access to get the party starts",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
//CAMERA .........................................................................
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60.0,
                            child: Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child:
                                          Image.asset("assets/images/camera.png"),
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Camera",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "To start live video chat",
                                            style: TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _askCameraPermission();
                                        /* Navigator.push(context, MaterialPageRoute(builder: (context)
                                  => HomeBody()));*/
                                      },
                                      child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: camera
                                                  ? Colors.green
                                                  : Colors.grey),
                                          child: Icon(
                                            Icons.check,
                                            size: 20,
                                            color: camera
                                                ? Colors.white
                                                : Colors.blueGrey,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: size.height * 0.03,
                        ),

//MICROPHONE.......................................................................
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60.0,
                            child: Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                        "assets/images/microphone.png"),
                                  ),
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Microphone",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "For voice calls",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _askMicPermission();
                                      /* Navigator.push(context, MaterialPageRoute(builder: (context)
                                => UserTwo()));*/
                                    },
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                mic ? Colors.green : Colors.grey),
                                        child: Icon(
                                          Icons.check,
                                          size: 24,
                                          color: mic
                                              ? Colors.white
                                              : Colors.blueGrey,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        //choiceDialog();
                        //openWelcomeDialog();
                      },
                      child: Container(
                        height: size.height,
                        width: size.width,
                        child: Center(
                          child: Container(
                            height: size.height / 3.5,
                            width: size.width / 1.5,
                            child: Image.asset("assets/images/callimage.png"),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void openSecurityDialog() {
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                        ),
                        child:Column(
                          children: <Widget>[
                            Container(
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
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child:
                                          Image.asset("assets/images/logo.png"),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Please be considerate so that everyone has good time here",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "Remember that there are 3 rules strictly forbidden",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Text(
                                          "1",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Abusive language, profanity, violent behaviour of any kind...",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Image.asset(
                                            "assets/images/logo.png"),
                                      ),
                                    )
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
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Text(
                                          "2",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Image.asset(
                                            "assets/images/logo.png"),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Images containing nudity or sexual content...",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    )
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
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Text(
                                          "3",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Tobacoo, alchol, drugs or similar substances...",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Image.asset(
                                            "assets/images/logo.png"),
                                      ),
                                    )
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
                                  hitRegisterAPi();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffec407a)),
                                  child: Center(
                                      child: Text(
                                    "I UNDERSTAND",
                                    style: TextStyle(
                                      color: Colors.white,
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
        });
  }

  bool camera = false;
  bool mic = false;

  void _askMicPermission() async {
    if (await Permission.microphone.request().isGranted) {
      _permissionStatus = await Permission.microphone.status;
      setState(() {
        mic = true;
      });

      if (camera && mic) {
        openSecurityDialog();
        /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
        => HomeBody()));*/
      }
    }
  }

  void _askCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      _permissionStatus = await Permission.camera.status;
      setState(() {
        camera = true;
      });
      if (camera && mic) {
        openSecurityDialog();
        /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
        => HomeBody()));*/
      }
    }
  }

  bool hitApi = false;
  Map<String, Object> json;

  Future<RegisterApi> hitRegisterAPi() async {
     prefs = await SharedPreferences.getInstance();
    showLoader(isModal: true);
    setState(() {
      //hitApi = true;
      json = {
        "deviceId": "" + MyHomePage.unique_id + "",
        //"deviceId": "" + AppConstant.DUMMY_ELEVEN + "",
        "name": "" +widget.name+"" ,
        "gender":  "" +widget.gender+"",
        "uuid":"1234"
      };
      debugPrint("JSON VALUE IS =" + json.toString());
    });

    Response response = await http
        .post(Uri.parse("http://13.127.44.197/adminTemplate/public/api/create"), body: json);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      print("Siple static ${response.body}");
      var userdetails = JSON.jsonDecode(response.body);
      setReReg(userdetails);

    }
  }

  void simpleInit(){
    try{
      QuickBloxLocal.init();
      QuickBloxLocal.auth();
      //QuickBloxLocal.initVideoCall();
    }catch(error){
      print("airlaaaaaaaa ${error}");
    }
  }

  void chatRegister(String id,String username,int uuid){
    print("rtyuuu ${username}");
    try{
      ApiRepository.postChatRegister(username, widget.gender, id,uuid).then((value) {

      }).catchError((error){});
    }catch(error){ print("holllllll");}
  }

  void openWelcomeDialog() {
    showDialog(
        builder: (context) => WillPopScope(
          onWillPop: () {
            // listen Android Back Button Pressed
            print("back");
            Navigator.pop(context);
            showDialog(
                builder: (context) => MyDialog(
                  onValueChange: _onValueChange,
                ), context: context);
            //return Future.value(true);

          },
          child: Align(
            child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                backgroundColor: Colors.transparent,
                content: Wrap(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                        ),
                        child:Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  gradient: RadialGradient(
                                    center: Alignment.center,
                                    colors: [
                                      kPrimaryLightColor,
                                      kPrimaryColor,
                                    ],
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 22.0, bottom: 22),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Welcome!",
                                      style: TextStyle(
                                          fontSize: 38,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 90,
                                          width: 90,
                                          child: Image.asset(
                                              "assets/images/coin.png"),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "+60",
                                          style: TextStyle(
                                              fontSize: 38,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "You've won free coins!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 38,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                )),
          ),
        ), context: context);
    /*builder: (BuildContext context) {
          return
        });*/
  }



  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  Future<void> setReg(userdetails,userdetails1) async {
    if (userdetails['status'] == "1") {
      int quid = await QuickBloxLocal.createQuickUser(userdetails["username"]);

      await ApiRepository.createQuickBloxKey(userdetails["id"], quid);
      chatRegister(userdetails['id'],userdetails["username"],quid);
      GetUserProfileModel gpModel = await ApiRepository.getUserProfileInitial(userdetails['id']);
      setState(() {
       is_user_login = true;
        prefs.setBool("is_login", is_user_login);
        prefs.setString("userid",userdetails['id']);
        prefs.setString("userName", userdetails["username"]);
        prefs.setString("paymentId", userdetails1["data"]['_id']);
        prefs.setString("userRole", gpModel.role);
        prefs.setInt(AppConstant.QUICKBLOX_USERID_STORE_KEY, quid);
        debugPrint("MY ID IS = "+userdetails['id']);
        call = true;

      });
      openWelcomeDialog();
    } else {
      Toast.show(userdetails["message"], context, duration: 4);
    }
  }

  Future<RegisterApi> setReReg(userdetails) async {
    prefs = await SharedPreferences.getInstance();
    showLoader(isModal: true);
    setState(() {
      //hitApi = true;
      json = {
        "userId": userdetails['id'],
        "userName": userdetails['username'],
        "email": "abc@gmail.com"
      };
      debugPrint("JSON VALUE IS =" + json.toString());
    });

    Response response = await http
        .post(Uri.parse("http://13.127.44.197:4600/api/users/createOrGet"), body: json);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      print("Siple static ${response.body}");
      var userdetails1 = JSON.jsonDecode(response.body);

      setReg(userdetails,userdetails1);
    }
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
                                "WHO DO YOU WANT TO TALK TO?",
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
                              Column(
                                children: [
                                  Text(
                                    'Female',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'comfortaa_semibold'),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height:20,
                                        width:20,
                                        child:Image.asset("assets/images/coin.png")
                                      ),
                                      Text("9",
                                      style: TextStyle(
                                        color:Colors.black
                                      ),)
                                    ],
                                  )
                                ],
                              ),
                              Radio(
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                value: 1,
                                groupValue: MyDialog.selectedRadioTile,
                                activeColor: kPrimaryColor,
                                onChanged: (val) {
                                  print("Radio $val");
                                  setSelectedRadioTile(val);
                                  setState(() {

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
                              Column(
                                children: [
                                  Text(
                                    'Male',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'comfortaa_semibold'),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height:20,
                                          width:20,
                                          child:Image.asset("assets/images/coin.png")
                                      ),
                                      Text("9",
                                        style: TextStyle(
                                            color:Colors.black
                                        ),)
                                    ],
                                  )
                                ],
                              ),
                              Radio(
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                value: 2,
                                groupValue: MyDialog.selectedRadioTile,
                                activeColor: kPrimaryColor,
                                onChanged: (val) {
                                  print("Radio $val");
                                  setSelectedRadioTile(val);
                                  setState(() {

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
                              Column(
                                children: [
                                  Text(
                                    'Both',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'comfortaa_semibold'),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height:20,
                                          width:20,
                                          child:Image.asset("assets/images/coin.png")
                                      ),
                                      Text("Free",
                                        style: TextStyle(
                                            color:Colors.black
                                        ),)
                                    ],
                                  )
                                ],
                              ),
                              Radio(
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                value: 3,
                                groupValue: MyDialog.selectedRadioTile,
                                activeColor: kPrimaryColor,
                                onChanged: (val) {
                                  print("Radio $val");
                                  setSelectedRadioTile(val);
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
                              Column(
                                children: [
                                  Text(
                                    'My Coins:',
                                    style: TextStyle(
                                        fontSize: 15.0,

                                        fontFamily: 'comfortaa_semibold'),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height:20,
                                          width:20,
                                          child:Image.asset("assets/images/coin.png")
                                      ),
                                      Text("60",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                            color:Colors.black
                                        ),)
                                    ],
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap:(){
                                  if(MyDialog.selectedRadioTile == null){
                                    Toast.show("Select your choice",context);
                                  }
                                  else{
                                    if(MyDialog.selectedRadioTile == 1){
                                      saveGenderFinal("Female");
                                      Toast.show("Female",context);
                                    }
                                    else if(MyDialog.selectedRadioTile == 2){
                                      saveGenderFinal("Male");
                                      Toast.show("Male",context);
                                    }
                                    else
                                      saveGenderFinal("Both");
                                      Toast.show("Both",context);
                                  //   Navigator.pushReplacement(context,
                                  // MaterialPageRoute(
                                  //     builder: (context)=>HomeScreen()
                                  //         //SearchingScreen(mychoice:MyDialog.selectedRadioTile)
                                  // )
                                  //   );
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      color:kPrimaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:12.0,right:12),
                                    child: Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  Future<bool> saveGender(String gender) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("localGender", gender);
    return true;
  }

  void saveGenderFinal(String gender){
    saveGender(gender).then((value) {
      return Navigator.pushReplacement(context,
          MaterialPageRoute(
          builder: (context)=>HomeScreen()
      //SearchingScreen(mychoice:MyDialog.selectedRadioTile)
      ));
    }).catchError((){});
  }


}