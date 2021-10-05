import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';

import 'package:hookezy/main.dart';
import 'package:hookezy/model/screens/register_api.dart';
import 'package:hookezy/model/screens/register_api.dart';
import 'package:hookezy/screens/ask_gender/screen_ask_gender.dart';
import 'package:hookezy/screens/ask_username_photo/components/background_ask_username_photo.dart';
import 'package:hookezy/screens/final_step/final_step_screen.dart';
import 'package:hookezy/screens/purchase_coins/screen_purchase_coins.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert' as JSON;

class AskUsernamePhotoBody extends StatefulWidget {
  @override
  _AskUsernamePhotoBodyState createState() => _AskUsernamePhotoBodyState();
}

class _AskUsernamePhotoBodyState extends State<AskUsernamePhotoBody> {
  final _formKey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  bool _autoValidate = false;
  bool is_user_login = false;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AskUsernamePhotoBackground(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height/35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width/3.4,
                        height: 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16),
                            ),
                            color: Color(0xffEC407A)
                        ),
                      ),
                      Container(
                        width: size.width/3.4,
                        height: 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16),
                            ),
                            color: Colors.grey
                        ),
                      ),
                      Container(
                        width: size.width/3.4,
                        height: 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16),
                            ),
                            color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  Container(
                    height: size.height * 0.12,
                    width: size.height * 0.12,
                    child: Image.asset("assets/images/contactbook.png"),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Text(
                    "Welcome! What's your name?",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
//NAME .........................................................................
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 48,
                            height: 60,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0, top: 22),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: new InputDecoration.collapsed(
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontFamily: 'comfortaa_semibold',
                                  ),
                                ),

                                textInputAction: TextInputAction.done,
                                controller: namecontroller,
                                keyboardType: TextInputType.text,
                                //style: TextStyle(color: Color(0xff7AD530)),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    color: Colors.white,
                  ),

                  SizedBox(
                    height: size.height * 0.51,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        if (namecontroller.text.isNotEmpty) {
                          //NAVIGATE TO THE NEXT VIEW
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                          => AskgenderScreen(name: namecontroller.text,)));
                        } else {
                          //PASSWORD DOES NOT MATCH
                          Toast.show("Enter Name", context, duration: 3);
                        }
                      } else {
                        setState(() {
                          _autoValidate = true;
                        });
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          gradient: LinearGradient(
                            colors: [Color(0xffEC407A), Color(0xffFD6296)],
                          )),
                      child: Center(
                        child: Text(
                          "CONTINUE",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
