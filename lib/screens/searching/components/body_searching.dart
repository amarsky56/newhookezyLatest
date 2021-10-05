import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/model/screens/audio_call_searching_user.dart';
import 'package:hookezy/screens/general/general_screen.dart';
import 'package:hookezy/screens/searching/components/background.dart';
import 'package:hookezy/screens/welcome/welcome_screen.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class SearchingBody extends StatefulWidget {
  int mychoice;
  SearchingBody({
    this.mychoice
  });
  @override
  _SearchingBodyState createState() => _SearchingBodyState();
}

class _SearchingBodyState extends State<SearchingBody> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SearchingBackground(
        child: Padding(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              SizedBox(
                height: size.height/40,
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                          height: 50,
                          width: 110,
                          decoration: BoxDecoration(
                            color: pink,
                            borderRadius:
                            BorderRadius.all(Radius.circular(32)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            "assets/images/coin.png")),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "63",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                          )),
                      Container(
                          height: 120,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: pink,
                            borderRadius:
                            BorderRadius.only(topLeft:Radius.circular(12),
                            topRight: Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 18, right: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("?",style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                    ),),
                              Text("Searching",style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                              ),),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context)=>HomeScreen()));
                                },
                                  child: Icon(
                                    Icons.exit_to_app,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
String gender;
  @override
  void initState() {
    super.initState();
    if(widget.mychoice == 1){
      setState(() {
        gender= "Female";
      });
      saveGender("Female");
    }
    else if(widget.mychoice == 2){
      setState(() {
        gender= "Male";
      });
      saveGender("Male");
    }
    else{
      setState(() {
        gender= "Both";
      });
      saveGender("Both");
    }
    hitSearchingApi();
  }

  Future<bool> saveGender(String gender) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("localGender", gender);
    return true;
  }


  Map<String, Object> json;
  bool hitApi = false;
  static var userdetails;
  Future<AudioCallSearchingUserApi> hitSearchingApi() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString("userid");
    debugPrint("userid = " + userid);
    json = {
      "category":gender
    };
    Response response =
    await http.put(Uri.parse(WelcomeScreen.baseurl+"randomByCategory/"+userid),body: json);

    if(response.statusCode == 200){

      userdetails = JSON.jsonDecode(response.body);

      debugPrint("RESPONSE IS ="+userdetails['isSuccess'].toString());
      if (userdetails['isSuccess'] == true) {
        debugPrint(userdetails['isSuccess'].toString());
      }
    }
    else if(response.statusCode == 400){
      setState(() {
        hitApi = false;
        Toast.show(userdetails['isSuccess'].toString(), context);
        debugPrint(userdetails['isSuccess'].toString());
      });
    }
  }
}
