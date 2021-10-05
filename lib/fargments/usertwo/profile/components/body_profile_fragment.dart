import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/usertwo/setting/screen_setting.dart';
import 'package:hookezy/screens/profile_screen/screen_profile.dart';


class ProfileFragmentBody extends StatefulWidget {
  @override
  _ProfileFragmentBodyState createState() => _ProfileFragmentBodyState();
}

class _ProfileFragmentBodyState extends State<ProfileFragmentBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pink,
        automaticallyImplyLeading: false,
        title: Text("Profile",
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Color(0xff282A39),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLUU4RH0MQoXrtxXHncCFi3H6S9saN_i49lQ&usqp=CAU")
                        )
                      //color: Colors.red,
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Mehak",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: pink
                    ),)
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: size.width,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey,width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    //background color of box
                    BoxShadow(
                      color: Color(0xff151515),
                      blurRadius: 3.0, // soften the shadow
                      spreadRadius: 1.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:8.0,right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Get Coins",
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                    Row(
                      children: [
                        Text("26",
                          style: TextStyle(
                            color: Colors.black,
                          ),),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                            height:20,
                            width: 20,
                            child: Image.asset("assets/images/coin.png")
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: Container(
                width: size.width,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8),
                  child: Row(
                    children: [
                      Text("Edit Profile",
                        style: TextStyle(
                          color: Colors.black,
                        ),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingScreenUsertwo()));
              },
              child: Container(
                width: size.width,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Settings",
                        style: TextStyle(
                          color: Colors.black,
                        ),),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: size.width,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey,width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:8.0,right: 8),
                child: Row(
                  children: [
                    Text("Help and Support",
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left:8.0,right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            color: Color(0xffEC407A),
                          ),
                          child: Center(
                            child: Icon(Icons.phone,
                            color: Colors.white,),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text("My Matches",
                          style: TextStyle(
                            color: Colors.black,
                          ),),
                        Text("0",
                          style: TextStyle(
                            color: Color(0xffEC407A),
                          ),),
                        Text("Buy More",
                          style: TextStyle(
                            color: Color(0xffEC407A),
                          ),),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            color: Color(0xff3D53C9),
                          ),
                          child: Center(
                            child: Icon(Icons.phone,
                              color: Colors.white,),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text("My Matches",
                          style: TextStyle(
                            color: Colors.black,
                          ),),
                        Text("0",
                          style: TextStyle(
                            color: Color(0xff3D53C9),
                          ),),
                        Text("Buy More",
                          style: TextStyle(
                            color: Color(0xff3D53C9),
                          ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
