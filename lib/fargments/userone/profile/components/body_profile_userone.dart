import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/userone/edit_profile/screen.dart';
import 'package:hookezy/fargments/userone/setting/components/body_setting.dart';
import 'package:hookezy/fargments/userone/setting/setting_screen.dart';
import 'package:hookezy/fargments/userthree/setting/screen_setting.dart';
import 'package:hookezy/fargments/usertwo/view_user2/screen_user.dart';
import 'package:hookezy/s/blocked_list.dart';
import 'package:hookezy/s/fav_list_ui.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/my_earning/my_earning.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/screens/discover/discover_screen.dart';
import 'package:hookezy/screens/profile_screen/screen_profile.dart';
import 'package:hookezy/screens/purchase_coins/components/body_purchase_coins.dart';
import 'package:hookezy/screens/purchase_coins/screen_purchase_coins.dart';

class ProfileFragmentUserone extends StatefulWidget {
  @override
  _ProfileFragmentUseroneState createState() => _ProfileFragmentUseroneState();
}

class _ProfileFragmentUseroneState extends State<ProfileFragmentUserone> {

  bool isError = false;
  bool isLoading = true;
  GetUserProfileModel getUserProfileModel;
  Size size;
  String userRole;

  void getProfilePayload(){
    ApiRepository.getUserProfile(1).then((value) {
      setState(() {
        getUserProfileModel = value;
      });
      return SHelper.returnUserRole();
    }).then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        userRole = value;
      });
    }).catchError((error){
      setState(() {
        getUserProfileModel = null;
        isError = true;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getProfilePayload();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
      body: uiPayload(),

    );
  }

  Widget uiPayload(){
    if(isError){
      return ErrorScreen(onRefresh: (){
        setState(() {
          isLoading = true;
        });
        getProfilePayload();
      });
    }else if(isLoading == true){
      return ProgressLoader(title: "Fetching Data",);
    }else{
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ViewUserScreentwo()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Color(0xff282A39),

                        //color: Colors.red,
                      ),
                      height: 50,
                      width: 50,
                      child: SNetWorkImage(
                        height: 50,
                        width: 50,
                        url: getUserProfileModel.details.image,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("${getUserProfileModel.name}",
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PurchaseCoinsBody(getUserProfileModel: getUserProfileModel,)));
              },
              child: Container(
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
                          Text("${getUserProfileModel.coinss}",
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
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UseroneProfileScreen()));
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
                    MaterialPageRoute(builder: (context) => UseroneSettingBody(gender: getUserProfileModel.gender,)));
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
            if(userRole == "Host")SizedBox(
              height: 16,
            ),
            if(userRole == "Host")GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>MyEarning()));
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
                      Container(
                          height:20,
                          width: 20,
                          child: Image.asset("assets/images/coin.png")
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("My Earning",
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
          ],
        ),
      );
    }
  }
}




