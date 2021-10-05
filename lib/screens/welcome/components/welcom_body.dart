import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hookezy/screens/ask_username_photo/screen_ask_username_photo.dart';

class WelcomeBody extends StatefulWidget {
  @override
  _WelcomeBodyState createState() => _WelcomeBodyState();
}

class _WelcomeBodyState extends State<WelcomeBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
              child: Image.asset("assets/images/hookgirl.jpg")),
          ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
              child: new Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade900.withOpacity(0.5)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(height:size.height/5.5,
                    child: Image.asset("assets/images/hlogo.png")),
                SizedBox(height: 10,),
                Text("Start talking anonymously. 30 seconds laer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),),
                Text("Camera will launch",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                  ),),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (context) => AskUsernamePhotoScreen()
                        ));
                  },
                  child: Container(
                    height: 50,
                    width: size.width-50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        gradient: LinearGradient(
                          colors: [Color(0xffEC407A), Color(0xffFD6296)],
                        )),
                    child: Center(
                      child: Text(
                        "START",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("By signing in you agree to privacy policy and",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                  ),),
                Text("terms of use.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),),

              ],
            ),
          )
        ],
      ),
    );
  }
}
