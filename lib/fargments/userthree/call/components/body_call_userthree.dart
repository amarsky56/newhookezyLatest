import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';

class CallFragmentBodyUserthree extends StatefulWidget {
  @override
  _CallFragmentBodyUserthreeState createState() => _CallFragmentBodyUserthreeState();
}

class _CallFragmentBodyUserthreeState extends State<CallFragmentBodyUserthree> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: pink,
        title: Text("Call",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kPrimaryColor,
                    kPrimaryLightColor,
                  ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 40,
                            width: 110,
                            decoration: BoxDecoration(
                              color: pink,
                                borderRadius:
                                BorderRadius.all(Radius.circular(7)),),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 16,
                                          width: 16,
                                          child: Image.asset("assets/images/key.png")),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Female",
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                    ],
                                  )),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 40,
                            width: 110,
                            decoration: BoxDecoration(
                              color: pink,
                              borderRadius:
                              BorderRadius.all(Radius.circular(7)),),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 16,
                                          width: 16,
                                          child: Image.asset("assets/images/coin.png")),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "61",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ],
                                  )),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height/4.9,
                  ),
                  Container(
                    height: size.height/3.5,
                    width: size.width/1.5,
                    child: Image.asset("assets/images/callimage.png"),
                  )                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
