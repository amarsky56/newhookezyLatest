import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/userone/profile/components/body_profile_userone.dart';
import 'package:hookezy/fargments/userthree/setting/screen_setting.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/screens/profile_screen/screen_profile.dart';

class ProfileBodyUserthree extends StatefulWidget {
  @override
  _ProfileBodyUserthreeState createState() => _ProfileBodyUserthreeState();
}

class _ProfileBodyUserthreeState extends State<ProfileBodyUserthree> {

  bool isError = false;
  bool isLoading = true;
  GetUserProfileModel getUserProfileModel;
  Size size;


  @override
  void initState() {
    // TODO: implement initState

    getProfilePayload();
    super.initState();
  }

  void getProfilePayload(){
    ApiRepository.getUserProfile(1).then((value) {
      setState(() {
        getUserProfileModel = value;
        isError = false;
        isLoading = false;
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
                    onTap: (){
                      Navigator
                          .of(context)
                          .push(new MaterialPageRoute(builder: (BuildContext context) {
                        return ProfileFragmentUserone();
                      }));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Color(0xff282A39),


                        //color: Colors.red,
                      ),
                      child: SNetWorkImage(height: 50,width: 50,url: getUserProfileModel.details.image,),
                      height: 50,
                      width: 50,
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
                        Text("23",
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
                    MaterialPageRoute(builder: (context) => SettingScreenUserThree()));
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
                    Container(
                        height:20,
                        width: 20,
                        child: Image.asset("assets/images/coin.png")
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text("My Earnings",
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
