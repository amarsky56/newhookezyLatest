import 'package:flutter/material.dart';
import 'package:hookezy/fargments/usertwo/setting/components/background_setting.dart';

class SettingBodyUsertwo extends StatefulWidget {
  @override
  _SettingBodyUsertwoState createState() => _SettingBodyUsertwoState();
}

class _SettingBodyUsertwoState extends State<SettingBodyUsertwo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff576a4),
          title: Text("Settings",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22, fontFamily: 'comfortaa_semibold'
              )
          ),
        ),
        body: SettingBackgroundUsertwo(
          child: Padding(
            padding: EdgeInsets.only(top: 16,bottom: 16),
            child: ListView(
              shrinkWrap: true,
              children: [
//BLOCKKED USERS................................................................
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xffE5E5E5),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left:18.0,right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Blocked Users",
                          style: TextStyle(
                              fontSize: 11.0,
                              color: Color(0xffEC407A),
                              fontFamily: 'comfortaa_semibold'
                          ),),
                        Container(
                          height: 12,
                          width: 12,
                          child: Image.asset("assets/images/rightarrow.png"),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),


//GENDER PREFERENCES...........................................................
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text("GENDER PREFERENCES",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffEC407A),
                        fontFamily: 'comfortaa_semibold'
                    ),),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xffE5E5E5),

                  child: Column(
                    children: [
//MALE..........................................................................
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8.0),
                        child: Container(
                          height:40,
                          child: Row(
                            children: [
                              Text("MALE",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0xffEC407A),
                                    fontFamily: 'comfortaa_semibold'
                                ),),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8),
                        child:  Divider(
                          color: Color(0xffEC407A).withOpacity(0.24),
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
//FEMALE........................................................................
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8.0),
                        child: Container(
                          height:40,
                          child: Row(
                            children: [
                              Text("FEMALE",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0xffEC407A),
                                    fontFamily: 'comfortaa_semibold'
                                ),),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8),
                        child:  Divider(
                          color: Color(0xffEC407A).withOpacity(0.24),
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

//BOTH..........................................................................
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8.0),
                        child: Container(
                          height:40,
                          child: Row(
                            children: [
                              Text("BOTH",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0xffEC407A),
                                    fontFamily: 'comfortaa_semibold'
                                ),),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8),
                        child:  Divider(
                          color: Color(0xffEC407A).withOpacity(0.24),
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

//CONTACT US...........................................................
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text("CONTACT US",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffEC407A),
                        fontFamily: 'comfortaa_semibold'
                    ),),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xffE5E5E5),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left:18.0,right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Help and Support",
                          style: TextStyle(
                              fontSize: 11.0,
                              color: Color(0xffEC407A),
                              fontFamily: 'comfortaa_semibold'
                          ),),
                        Container(
                          height: 12,
                          width: 12,
                          child: Image.asset("assets/images/rightarrow.png"),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),


//LEGAL...........................................................
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text("LEGAL",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffEC407A),
                        fontFamily: 'comfortaa_semibold'
                    ),),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xffE5E5E5),

                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8.0),
                        child: Container(
                          height:40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Privacy Policy",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0xffEC407A),
                                    fontFamily: 'comfortaa_semibold'
                                ),),
                              Container(
                                height: 12,
                                width: 12,
                                child: Image.asset("assets/images/rightarrow.png"),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8),
                        child:  Divider(
                          color: Color(0xffEC407A).withOpacity(0.24),
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
//TEarms of use.................................................................
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8.0),
                        child: Container(
                          height:40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tearms Of Use",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0xffEC407A),
                                    fontFamily: 'comfortaa_semibold'
                                ),),
                              Container(
                                height: 12,
                                width: 12,
                                child: Image.asset("assets/images/rightarrow.png"),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8),
                        child:  Divider(
                          color: Color(0xffEC407A).withOpacity(0.24),
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

//COMMUNITY GUIDELINES..........................................................................
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8.0),
                        child: Container(
                          height:40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("COMMUNITY GUIDELINES",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0xffEC407A),
                                    fontFamily: 'comfortaa_semibold'
                                ),),
                              Container(
                                height: 12,
                                width: 12,
                                child: Image.asset("assets/images/rightarrow.png"),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8),
                        child:  Divider(
                          color: Color(0xffEC407A).withOpacity(0.24),
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

//SUBSCRIPTION...........................................................
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text("SUBSCRIPTION",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffEC407A),
                        fontFamily: 'comfortaa_semibold'
                    ),),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xffE5E5E5),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left:18.0,right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Check Subscription Status",
                          style: TextStyle(
                              fontSize: 11.0,
                              color: Color(0xffEC407A),
                              fontFamily: 'comfortaa_semibold'
                          ),),
                        Container(
                          height: 12,
                          width: 12,
                          child: Image.asset("assets/images/rightarrow.png"),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        )
    );
  }
}
