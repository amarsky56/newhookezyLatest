import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/s/model/leaderboard_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/helper.dart';

class LeaderBodyUserthree extends StatefulWidget {
  @override
  _LeaderBodyUserthreeState createState() => _LeaderBodyUserthreeState();
}

class _LeaderBodyUserthreeState extends State<LeaderBodyUserthree> {
  bool hours = true;
  BoxDecoration pinkdecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(7)),
      gradient: LinearGradient(
        colors: [Color(0xffEC407A), Color(0xffFD6296)],
      ));
  TextStyle whitedecoration = TextStyle(color: Colors.white);

  TextStyle greydecoration = TextStyle(color: Colors.grey);
  bool isError = true;
  bool isLoading = false;
  LeaderBoardModel leaderBoardModel;
  String userId;

  int WEEKLY = 1;
  int HOURS = 2;
  int selectedIndex = 2;

  void getUserId(){
    SHelper.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  void fetechData() {
    setState(() {
      isLoading = true;
      isError = false;
    });
    ApiRepository.getLeaderboard(selectedIndex).then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        leaderBoardModel = value;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
        isError = true;
        leaderBoardModel = null;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserId();
    fetechData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: pink,
        title: Text(
          "Leader",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: uiPayload(),
    );
  }

  List<Arr> getSingleElement() {
    //return leaderBoardModel.myrankArr;
    return leaderBoardModel.myrankArr.where((element) => element.id == userId).toList();
  }

  Widget uiPayload(){
    if(isLoading){
      return ProgressLoader(title: "Fetching Data...",);
    }else if(isError){
      return ErrorScreen(onRefresh: (){ return fetechData();},);
    }else{
      return Column(
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = HOURS;
                    });
                    fetechData();
                  },
                  child: Container(
                      height: 40,
                      width: 110,
                      decoration: selectedIndex == HOURS
                          ? pinkdecoration
                          : BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(7)),
                          border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Center(
                            child: Text(
                              "Last 24 Hours",
                              style: selectedIndex == HOURS ? whitedecoration : greydecoration,
                            )),
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = WEEKLY;
                    });
                    fetechData();
                  },
                  child: Container(
                      height: 40,
                      width: 110,
                      decoration: selectedIndex != WEEKLY
                          ? BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(7)),
                          border: Border.all(color: Colors.grey)):pinkdecoration,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Center(
                            child: Text(
                              "This Week",
                              style: selectedIndex != WEEKLY ?greydecoration:whitedecoration,
                            )),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Expanded(
          //     child: Container(
          //       child: Column(
          //         children: [
          //           ListView.builder(
          //             itemBuilder: (context, positon) {
          //               return Column(
          //                 children: [
          //                   Container(
          //                     height: 50,
          //                     child: Padding(
          //                       padding: const EdgeInsets.only(left: 8, right: 8),
          //                       child: Row(
          //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Row(
          //                             children: [
          //                               Text(
          //                                 "${positon+1}",
          //                                 style: TextStyle(
          //                                     color: Colors.pink,
          //                                     fontSize: 20,
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               SizedBox(
          //                                 width: 16,
          //                               ),
          //                               Container(
          //                                 decoration: BoxDecoration(
          //                                     borderRadius: BorderRadius.all(
          //                                         Radius.circular(100)),
          //                                     color: Color(0xff282A39),
          //                                     image: DecorationImage(
          //                                         fit: BoxFit.fill,
          //                                         image: NetworkImage(
          //                                             "${leaderBoardModel.leaderboardArr[positon].image}"))
          //                                   //color: Colors.red,
          //                                 ),
          //                                 height: 50,
          //                                 width: 50,
          //                               ),
          //                               SizedBox(
          //                                 width: 16,
          //                               ),
          //                               Column(
          //                                 mainAxisAlignment: MainAxisAlignment.center,
          //                                 crossAxisAlignment: CrossAxisAlignment.start,
          //                                 children: [
          //                                   Text(
          //                                     "${leaderBoardModel.leaderboardArr[positon].obfuscateName}",
          //                                     style: TextStyle(
          //                                         fontSize: 16,
          //                                         fontWeight: FontWeight.bold),
          //                                   ),
          //                                   Text(
          //                                     "Country: ${leaderBoardModel.leaderboardArr[positon].country}.......",
          //                                     style: TextStyle(fontSize: 12),
          //                                   )
          //                                 ],
          //                               )
          //                             ],
          //                           ),
          //                           Row(
          //                             children: [
          //                               Container(
          //                                 height: 20,
          //                                 width: 20,
          //                                 child: Image.asset("assets/images/coin.png"),
          //                               ),
          //                               SizedBox(
          //                                 width: 10,
          //                               ),
          //                               Text(
          //                                 "${leaderBoardModel.leaderboardArr[positon].coins}",
          //                                 style: TextStyle(color: Colors.black),
          //                               )
          //                             ],
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 16,
          //                   )
          //                 ],
          //               );
          //             },
          //             itemCount: leaderBoardModel.leaderboardArr.length,
          //           )
          //         ],
          //       ),
          //     ))
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                leaderBoardModel.leaderboardArr.isNotEmpty ? ListView.builder(
                  itemBuilder: (context, positon) {
                    return Column(
                      children: [
                        Container(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${positon+1}",
                                      style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          color: Color(0xff282A39),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  "${leaderBoardModel.leaderboardArr[positon].image}"))
                                        //color: Colors.red,
                                      ),
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${leaderBoardModel.leaderboardArr[positon].obfuscateName}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Country: ${leaderBoardModel.leaderboardArr[positon].country}.......",
                                          style: TextStyle(fontSize: 14),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset("assets/images/coin.png"),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${leaderBoardModel.leaderboardArr[positon].coins}",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    );
                  },
                  itemCount: leaderBoardModel.leaderboardArr.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ) : Container(child: Center(child: Text("No Data Available",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),),
                ListView.builder(
                  itemBuilder: (context, positon) {
                    return Column(
                      children: [
                        Container(
                          height: 80,
                          color: Colors.pink,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8,top: 8.0,bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${positon+1}",
                                      style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          color: Color(0xff282A39),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  "${leaderBoardModel.leaderboardArr[positon].image}"))
                                        //color: Colors.red,
                                      ),
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${leaderBoardModel.leaderboardArr[positon].obfuscateName}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Country: ${leaderBoardModel.leaderboardArr[positon].country}.......",
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset("assets/images/coin.png"),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${leaderBoardModel.leaderboardArr[positon].coins}",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    );
                  },
                  itemCount: getSingleElement().length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                )
              ],
            ),
          ))
        ],
      );
    }
  }
}
