// import 'package:carousel_pro/carousel_pro.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_app/constanst.dart';
// import 'package:flutter_app/fragments/home_fragment/components/catagory.dart';
// import 'package:flutter_app/fragments/home_fragment/components/drawer.dart';
// import 'package:flutter_app/fragments/home_fragment/components/h_f_background.dart';
// import 'package:dashed_circle/dashed_circle.dart';
// import 'package:flutter_app/fragments/home_fragment/components/leaderboard_view.dart';
// import 'package:flutter_app/fragments/home_fragment/components/post.dart';
// import 'package:flutter_app/fragments/home_fragment/components/stories.dart';
// import 'package:flutter_app/inner_screens/notification_screen/screen_notification.dart';
// import 'package:flutter_app/inner_screens/search_screen/screen_search.dart';
// import 'package:flutter_app/inner_screens/story/stroy_view.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter_app/model/fragments/homelisting/home_listing_api.dart';
// import 'package:flutter_app/screens/login/components/body.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';
// import 'package:http/http.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as JSON;
//
// import 'package:video_player/video_player.dart';
// import 'example_data.dart' as Example;
//
// class HomeFragmentBody extends StatefulWidget {
//
//   static bool selectedtrending = true;
//   static bool selectednew = false;
//   static bool selectedleaderboard = false;
//   static List posts = [];
//   static List stories = [];
//   static List likebool = [];
//   static List reactionGif = [];
//   static List likeGif = [];
//   static List loveGif = [];
//   static List hahaGif = [];
//   static List careGif = [];
//   static List heartbool = [];
//   static List laughbool = [];
//   static List carebool = [];
//
//
//   static List<String> pageFollowed = [];
//   static List<String> newpageFollowed = [];
//
//   static VideoPlayerController videoPlayerController;
//   static List<String> postvideo = [];
//   static List<String> newpostvideo = [];
//
//
//   static List<int> allLikes = [];
//   static List<int> onlyLikes = [];
//   static List<int> onlyHeart = [];
//   static List<int> onlyLaugh = [];
//   static List<int> onlyCare = [];
//
//
//   static List newposts = [];
//   static List newlikebool = [];
//   static List newheartbool = [];
//   static List newlaughbool = [];
//   static List newcarebool = [];
//
//
//   static List<int> newallLikes = [];
//   static List<int> newonlyLikes = [];
//   static List<int> newonlyHeart = [];
//   static List<int> newonlyLaugh = [];
//   static List<int> newonlyCare = [];
//   static var name;
//   @override
//   _HomeFragmentBodyState createState() => _HomeFragmentBodyState();
//
//   static void hitGetHomeDataApi() {}
// }
//
// class _HomeFragmentBodyState extends State<HomeFragmentBody> with SingleTickerProviderStateMixin {
//
//
//   RefreshController _refreshController =
//   RefreshController(initialRefresh: false);
//
//   Text selected = Text("Leaderboard",
//       style: TextStyle(
//           fontSize: 18, color: Colors.white,
//           shadows: <Shadow>[
//             Shadow(
//               offset: Offset(2.0, 2.0),
//               blurRadius: 3.0,
//               color: Colors.black87,
//             ),
//             Shadow(
//               offset: Offset(2.0, 2.0),
//               blurRadius: 3.0,
//               color: orangecolor,
//             ),
//           ]));
//
//   Text newtext = Text("New",
//       style: TextStyle(
//           fontSize: 18, color: Colors.white,
//           shadows: <Shadow>[
//             Shadow(
//               offset: Offset(2.0, 2.0),
//               blurRadius: 3.0,
//               color: Colors.black87,
//             ),
//             Shadow(
//               offset: Offset(2.0, 2.0),
//               blurRadius: 3.0,
//               color: orangecolor,
//             ),
//           ]));
//
//   Text trendingtext = Text("Trending",
//       style: TextStyle(
//           fontSize: 18, color: Colors.white,
//           shadows: <Shadow>[
//             Shadow(
//               offset: Offset(2.0, 2.0),
//               blurRadius: 3.0,
//               color: Colors.black87,
//             ),
//             Shadow(
//               offset: Offset(2.0, 2.0),
//               blurRadius: 3.0,
//               color: orangecolor,
//             ),
//           ]));
//
//
//   String firstbanner,secondbanner,thirdbanner;
//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//       context: context,
//       builder: (context) =>
//           AlertDialog(
//             title: Text('Are you sure?'),
//             content: Text('Do you want to exit an App'),
//             actions: <Widget>[
//               FlatButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: new Text('No'),
//               ),
//               FlatButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 child: new Text('Yes'),
//               ),
//             ],
//           ),
//     )) ?? false;
//   }
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery
//         .of(context)
//         .size;
//     ScrollController _scrollController = ScrollController();
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Container(
//               height: 50,
//               width: size.width/4.9,
//               child: Image.asset('assets/images/logo.png', fit: BoxFit.cover)),
//
//           actions: [
//
//             IconButton(
//                 icon: Icon(
//                   Icons.search,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(
//                           builder: (context) => SearchScreen()));
//                 }),
//             IconButton(
//                 icon: Icon(
//                   Icons.notifications_active,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(
//                           builder: (context) => NotificationScreen()));
//                 }),
//
//           ],
//         ),
//
//         drawer: Theme(
//           data: Theme.of(context)
//               .copyWith( //This will change the drawer background to blue.
//             //other styles
//           ),
//           child: Drawer(
//
//             child: HomeDrawer(),
//           ),
//         ),
//         body: HomeFragmentBackground(
//           child: Padding(
//             padding: EdgeInsets.only(top:16.0),
//             child: Scrollbar(
//               child: SmartRefresher(
//                 controller: _refreshController,
//                 enablePullDown: true,
//                 onRefresh: _onRefresh,
//                 onLoading: _onLoading,
//                 header: WaterDropHeader(),
//                 child: SingleChildScrollView(
//                   child: Container(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//
//                         // trending, new, leaderboard
//                         //Trending, new, leaderboard catagories in it.
//                       Container(
//                       height: 30,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 HomeFragmentBody.selectedtrending = true;
//                                 HomeFragmentBody.selectednew = false;
//                                 HomeFragmentBody.selectedleaderboard = false;
//                                 HomeFragmentBody.posts.clear();
//                                 hitGetHomeTrendingDataApi();
//                               });
//                             },
//                             child: Container(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Timeline",
//                                       style: TextStyle(
//                                         fontFamily: 'comfortaa_semibold',
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     Visibility(
//                                       visible: HomeFragmentBody.selectedtrending,
//                                       child: Container(
//                                         height: 2,
//                                         width: size.width/5.9,
//                                         color: Colors.grey,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 HomeFragmentBody.selectedtrending = false;
//                                 HomeFragmentBody.selectednew = true;
//                                 HomeFragmentBody.selectedleaderboard = false;
//                                 HomeFragmentBody.newposts.clear();
//                                 hitGetHomeNewDataApi();
//                               });
//                             },
//                             child: Container(
//                               //decoration: selectednew ? decoration : decoration1,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("New",
//                                         style: TextStyle(fontSize: 16,
//                                             fontFamily: 'comfortaa_semibold')),
//                                     Visibility(
//                                       visible: HomeFragmentBody.selectednew,
//                                       child: Container(
//                                         height: 2,
//                                         width: size.width/9,
//                                         color: Colors.grey,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 HomeFragmentBody.selectedtrending = false;
//                                 HomeFragmentBody.selectednew = false;
//                                 HomeFragmentBody.selectedleaderboard = true;
//                               });
//                             },
//                             child: Container(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                                 child:  Column(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Leaderboard",style: TextStyle(
//                                         fontSize: 16,
//                                         fontFamily: 'comfortaa_semibold'
//                                     ),
//                                     ),
//                                     Visibility(
//                                       visible: HomeFragmentBody.selectedleaderboard,
//                                       child: Container(
//                                         height: 2,
//                                         width: size.width/4,
//                                         color: Colors.grey,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//
//                         //SizedBox(height: size.height * 0.03),
// //row contains text STORIES and add stroies button............................
//                         /* Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                                 "Stories",
//                               style: TextStyle(color: Colors.white,fontSize: 18),
//                             ),
//                            */
// //............................................................................
//                         SizedBox(height: size.height * 0.02),
// //Container containes the stories like instagram................................
//                         !HomeFragmentBody.selectedleaderboard?
//                         HomeFragmentBody.stories.length>=1?
//                         UserStories():
//                             Container()
//                             :Container(),
//
// //..............................................................................
//                         Visibility(
//                             visible: !HomeFragmentBody.selectedleaderboard,
//                             child: SizedBox(height: size.height * 0.03)),
// //Container contains the slider of three pictures...............................
//                         !HomeFragmentBody.selectedleaderboard? banner.isNotEmpty?
//                         Container(
//                           height: size.height * 0.27,
//
//                           /*child: banner.isNotEmpty?
//                           myWidget:Container(),*/
//                           child:
//                           Stack(
//                             children: [
//                               CarouselSlider(
//                                 initialPage: 1,
//                                 onPageChanged: (index) {
//                                   //Toast.show("changed",context);
//
//                                   setState(() {
//                                     _current = index;
//                                    // print("${_current}");
//                                   });
//                                 },
//                                 //height: MediaQuery.of(context).size.height * 0.60,
//                                 items: <Widget>[
//                                   for (var i = 0; i < banner.length; i++)
//                                     Container(
//                                       width: size.width,
//                                       margin: const EdgeInsets.only( left: 20.0),
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           image: NetworkImage(banner[i]),
//                                           fit: BoxFit.fitHeight,
//                                         ),
//                                         // border:
//                                         //     Border.all(color: Theme.of(context).accentColor),
//                                         borderRadius: BorderRadius.circular(32.0),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//
//                               Positioned(
//                                 top: size.height*0.2,
//                                 left: size.width/2.9,
//                                 child: Container(
//                                   height: 20,
//                                   child: Center(
//                                     child: Container(
//
//                                       width: 100,
//                                       child: ListView.builder(
//
//                                         scrollDirection: Axis.horizontal,
//                                         itemBuilder:
//                                             (context,position){
//                                           return Container(
//                                             width: 10.0,
//                                             height: 10.0,
//                                             margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
//                                             decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: _current == position
//                                                     ? Color(0xff7AD530)
//                                                     : orangecolor),
//                                           );
//                                         },
//                                         itemCount: banner.length,),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ):Container():Container(),
//
//                         //............................................................................
//
//
//                         //............................................................................
//                         banner.isNotEmpty?SizedBox(height: size.height * 0.00):
//                         Container(),
//                         //Userposts are coming in it.
//
//                         !HomeFragmentBody.selectedleaderboard?HomeFragmentBody.selectedtrending ?HomeFragmentBody.posts.isNotEmpty?UserPost(Example.reactions):Container():
//                         HomeFragmentBody.newposts.isNotEmpty?UserPost(Example.reactions):Container():
//                             Container(
//                               height: size.height*0.70,
//                                 child:Column(
//                                 children: [
//                                   Container(
//                                     height: 40,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           child:Container(
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.all(Radius.circular(4)),
//                                               border: Border.all(
//                                                   color: Colors.grey,
//                                                   width: 1
//                                               ),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left:4.0,right: 4.0),
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Column(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           Text("StartDate",
//                                                             style: TextStyle(
//                                                               fontSize: 10,
//                                                                 fontFamily: 'comfortaa_semibold'
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             width: 4,
//                                                           ),
//                                                           Text("02-02-2021",
//                                                             style: TextStyle(
//                                                                 fontSize: 10,
//                                                                 fontFamily: 'comfortaa_semibold'
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                       Row(
//                                                         children: [
//                                                           Text("EndDate",
//                                                             style: TextStyle(
//                                                                 fontSize: 10,
//                                                                 fontFamily: 'comfortaa_semibold'
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             width: 4,
//                                                           ),
//                                                           Text("09-02-2021",
//                                                             style: TextStyle(
//                                                                 fontSize: 10,
//                                                                 fontFamily: 'comfortaa_semibold'
//                                                             ),
//                                                           )
//                                                         ],
//                                                       )
//                                                     ],
//                                                   ),
//                                                   Row(
//                                                     children: [
//                                                       Container(
//                                                         height:20,
//                                                         width: 20,
//                                                         child:(Image.asset("assets/images/stopwatch.png")),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 4,
//                                                       ),
//                                                       Text("56h-45m-56s",
//                                                       style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontFamily: 'comfortaa_semibold'
//                                                       ),)
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ),
//                                         SizedBox(
//                                           width: 16,
//                                         ),
//                                         Container(
//                                           width: 80,
//                                           height: 40,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.all(Radius.circular(4)),
//                                               border: Border.all(
//                                                   color: Colors.grey,
//                                                   width: 1
//                                               ),
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Icon(Icons.info,
//                                               size: 24,),
//                                               SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Text("Info",
//                                               style: TextStyle(
//                                                 fontSize: 13,
//                                                   fontFamily: 'comfortaa_semibold'
//                                               ),)
//                                             ],
//
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Container(
//                                     height: 40,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           width: 60,
//                                           height: 40,
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Text("Rank",
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontFamily: 'comfortaa_semibold'
//                                                 ),)
//                                             ],
//
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 16,
//                                         ),
//                                         Expanded(
//                                             child:Container(
//
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(left:4.0,right: 4.0),
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Text("Page Name",
//                                                           style: TextStyle(
//                                                               fontSize: 15,
//                                                               fontFamily: 'comfortaa_semibold'
//                                                           ),)
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             )
//                                         ),
//                                         Container(
//                                           width: 80,
//                                           height: 40,
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Text("Score",
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontFamily: 'comfortaa_semibold'
//                                                 ),)
//                                             ],
//
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                   LeaderboardScore(),
//                                 ],
//                             )
//                             )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     HomeFragmentBody.posts.clear();
//     HomeFragmentBody.likebool.clear();
//     HomeFragmentBody.heartbool.clear();
//     HomeFragmentBody.laughbool.clear();
//     HomeFragmentBody.carebool.clear();
//
//
//     HomeFragmentBody.allLikes.clear();
//     HomeFragmentBody.onlyLikes.clear();
//     HomeFragmentBody.onlyHeart.clear();
//     HomeFragmentBody.onlyLaugh.clear();
//     HomeFragmentBody.onlyCare.clear();
//
//
//
//     HomeFragmentBody.newposts.clear();
//
//     HomeFragmentBody.newlikebool.clear();
//     HomeFragmentBody.newheartbool.clear();
//     HomeFragmentBody.newlaughbool.clear();
//     HomeFragmentBody.newcarebool.clear();
//
//
//     HomeFragmentBody.newallLikes.clear();
//     HomeFragmentBody.newonlyLikes.clear();
//     HomeFragmentBody.newonlyHeart.clear();
//     HomeFragmentBody.newonlyLaugh.clear();
//     HomeFragmentBody.newonlyCare.clear();
//
//     setState(() {
//       HomeFragmentBody.selectedtrending = true;
//       HomeFragmentBody.selectednew = false;
//       HomeFragmentBody.selectedleaderboard = false;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     HomeFragmentBody.selectedtrending?hitGetHomeTrendingDataApi():
//     hitGetHomeNewDataApi();
//     print("VALUE OF THE "+HomeFragmentBody.selectedtrending.toString()+
//         HomeFragmentBody.selectednew.toString()+
//         HomeFragmentBody.selectedleaderboard.toString());
//   }
//
//   //String image = "https://cdn.searchenginejournal.com/wp-content/uploads/2020/08/5e57a8b5-e0f0-402f-ac32-4f9d0ae914ea-5f32e90ab038c-1520x800.png";
//   Widget myWidget = Container(
//     /*child: CarouselSlider(
//       autoPlay: true,
//       pauseAutoPlayOnTouch: Duration(seconds: 5),
//       height: MediaQuery.of(context).size.height * 0.60,
//       items: <Widget>[
//         for (var i = 0; i < image.length; i++)
//           Container(
//             margin: const EdgeInsets.only(top: 20.0, left: 20.0),
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(image[i]),
//                 fit: BoxFit.fitHeight,
//               ),
//               // border:
//               //     Border.all(color: Theme.of(context).accentColor),
//               borderRadius: BorderRadius.circular(32.0),
//             ),
//           ),
//       ],
//     ),*/
//     /*child: Carousel(
//       boxFit: BoxFit.cover,
//       autoplay: true,
//       dotBgColor: Colors.transparent,
//       dotColor: Color(0xff7AD530),
//       moveIndicatorFromBottom: 10.0,
//       radius: Radius.circular(16),
//       borderRadius: true,
//       animationCurve: Curves.fastOutSlowIn,
//       animationDuration: Duration(microseconds: 2000),
//       images: [netimages],
//     ),*/
//   );
//
//   Map<String, Object> json;
//   bool hitApi = false;
//   static var userdetails;
//   List banner = [];
//
//   int _current = 1;
//
//   Future<HomeListingApi> hitGetHomeNewDataApi() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String mytoken = preferences.getString("token");
//     setState(() {
//       hitApi = true;
//       json = {
//         "type": "N"
//       };
//       debugPrint("value of json is " + json.toString());
//     });
//
//     Response response =
//     await http.post(
//       Body.baseurl + "homeListing", body: json, headers: {"token": mytoken},);
//
//     if (response.statusCode == 200) {
//       setState(() {
//         hitApi = false;
//       });
//       userdetails = JSON.jsonDecode(response.body);
//       if (userdetails['status'] == "1")
//         Toast.show("New data", context);
//       debugPrint("new data is ="+userdetails['posts'].toString());
//       setState(() {
//         HomeFragmentBody.newposts = userdetails['posts'];
//         HomeFragmentBody.likebool.clear();
//         HomeFragmentBody.heartbool.clear();
//         HomeFragmentBody.carebool.clear();
//         HomeFragmentBody.laughbool.clear();
//         if(HomeFragmentBody.reactionGif.isNotEmpty){
//           HomeFragmentBody.reactionGif.clear();
//           HomeFragmentBody.likeGif.clear();
//           HomeFragmentBody.loveGif.clear();
//           HomeFragmentBody.hahaGif.clear();
//           HomeFragmentBody.careGif.clear();
//         }
//
//         HomeFragmentBody.allLikes.clear() ;
//
//         HomeFragmentBody.onlyLikes.clear();
//         HomeFragmentBody.onlyHeart.clear();
//         HomeFragmentBody.onlyLaugh.clear();
//         HomeFragmentBody.onlyCare.clear();
//         HomeFragmentBody.pageFollowed.clear();
//         HomeFragmentBody.postvideo.clear();
//       });
//
//       for(int a=0; a<HomeFragmentBody.newposts.length; a++){
//
//         setState(() {
//           HomeFragmentBody.newlikebool.add(false);
//           HomeFragmentBody.newheartbool.add(false);
//           HomeFragmentBody.newcarebool.add(false);
//           HomeFragmentBody.newlaughbool.add(false);
//           HomeFragmentBody.reactionGif.add(false);
//           HomeFragmentBody.likeGif.add(false);
//           HomeFragmentBody.loveGif.add(false);
//           HomeFragmentBody.hahaGif.add(false);
//           HomeFragmentBody.careGif.add(false);
//
//           HomeFragmentBody.newallLikes.add( HomeFragmentBody.newposts[a]['likes_count']) ;
//
//           HomeFragmentBody.newonlyLikes.add(HomeFragmentBody.newposts[a]['thumbs_count']);
//           HomeFragmentBody.newonlyHeart.add(HomeFragmentBody.newposts[a]['heart_count']);
//           HomeFragmentBody.newonlyLaugh.add(HomeFragmentBody.newposts[a]['smile_count']);
//           HomeFragmentBody.newonlyCare.add(HomeFragmentBody.newposts[a]['flower_count']);
//           HomeFragmentBody.newpageFollowed.add(HomeFragmentBody.newposts[a]["page_followed"]);
//           HomeFragmentBody.newposts[a]['media'][0]['media'].split('.').last=="mp4"?
//           HomeFragmentBody.newpostvideo.add(HomeFragmentBody.newposts[a]['media'][0]['media'])
//               :HomeFragmentBody.newpostvideo.add("");
//           debugPrint("pppppppppppp  "+HomeFragmentBody.newpostvideo.toString());
//           /*HomeFragmentBody.videoPlayerController = VideoPlayerController.network(HomeFragmentBody.newpostvideo[a])
//             ..initialize().then((_) {
//               // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//               setState(() {});
//             });*/
//         });
//
//       }
//
//
//       banner = userdetails['banners'];
//       if(banner.isNotEmpty){
//         for(int b=0; b<banner.length; b++){
//           debugPrint("BANNER IS ="+banner[b]);
//         }
//       }
//
//     }  else{
//       setState(() {
//         hitApi = false;
//         Toast.show(response.statusCode.toString(), context);
//       });
//     }
//   }
//
//
//
//   Future<HomeListingApi> hitGetHomeTrendingDataApi()  async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String mytoken = preferences.getString("token");
//     setState(() {
//       hitApi = true;
//       json = {
//         "type": "T"
//       };
//       debugPrint("value of json is " + json.toString());
//     });
//
//     Response response =
//         await http.post(
//       Uri.parse(Body.baseurl + "homeListing"), body: json, headers: {"token": mytoken},);
//
//     if (response.statusCode == 200) {
//       setState(() {
//         hitApi = false;
//       });
//
//       userdetails = JSON.jsonDecode(response.body);
//       if (userdetails['status'] == "1")
//         Toast.show("Trenging data", context);
//       setState(() {
//         HomeFragmentBody.posts = userdetails['posts'];
//         HomeFragmentBody.stories = userdetails['stories'];
//         HomeFragmentBody.newlikebool.clear();
//         HomeFragmentBody.newheartbool.clear();
//         HomeFragmentBody.newcarebool.clear();
//         HomeFragmentBody.newlaughbool.clear();
//         if(HomeFragmentBody.reactionGif.isNotEmpty){
//           HomeFragmentBody.reactionGif.clear();
//           HomeFragmentBody.likeGif.clear();
//           HomeFragmentBody.loveGif.clear();
//           HomeFragmentBody.hahaGif.clear();
//           HomeFragmentBody.careGif.clear();
//         }
//
//
//         HomeFragmentBody.newallLikes.clear();
//
//         HomeFragmentBody.newonlyLikes.clear();
//         HomeFragmentBody.newonlyHeart.clear();
//         HomeFragmentBody.newonlyLaugh.clear();
//         HomeFragmentBody.newonlyCare.clear();
//         HomeFragmentBody.newpageFollowed.clear();
//         HomeFragmentBody.newpostvideo.clear();
//
//       });
//
//       debugPrint("POST DATA IS ="+HomeFragmentBody.stories.length.toString());
//       for(int a=0; a<HomeFragmentBody.posts.length; a++){
//         HomeFragmentBody.likebool.add(false);
//         HomeFragmentBody.heartbool.add(false);
//         HomeFragmentBody.carebool.add(false);
//         HomeFragmentBody.laughbool.add(false);
//         HomeFragmentBody.reactionGif.add(false);
//         HomeFragmentBody.likeGif.add(false);
//         HomeFragmentBody.loveGif.add(false);
//         HomeFragmentBody.hahaGif.add(false);
//         HomeFragmentBody.careGif.add(false);
//         setState(() {
//           HomeFragmentBody.allLikes.add( HomeFragmentBody.posts[a]['likes_count']) ;
//
//           HomeFragmentBody.onlyLikes.add(HomeFragmentBody.posts[a]['thumbs_count']);
//           HomeFragmentBody.onlyHeart.add(HomeFragmentBody.posts[a]['heart_count']);
//           HomeFragmentBody.onlyLaugh.add(HomeFragmentBody.posts[a]['smile_count']);
//           HomeFragmentBody.onlyCare.add(HomeFragmentBody.posts[a]['flower_count']);
//           HomeFragmentBody.pageFollowed.add(HomeFragmentBody.posts[a]["page_followed"]);
//           HomeFragmentBody.posts[a]['media'][0]['media'].split('.').last==".mp4"?
//               HomeFragmentBody.postvideo.add(HomeFragmentBody.posts[a]['media'][0]['media'])
//               :HomeFragmentBody.postvideo.add("");
//         });
//
//       }
//
//       debugPrint("POST DATA IS ="+HomeFragmentBody.postvideo.toString());
//       banner = userdetails['banners'];
//       if(banner.isNotEmpty){
//         for(int b=0; b<banner.length; b++){
//           debugPrint("BANNER IS ="+banner[b]);
//         }
//       }
//     }  else{
//       setState(() {
//         hitApi = false;
//         Toast.show(response.statusCode.toString(), context);
//       });
//     }
//   }
//   void _onRefresh() async{
//     // monitor network fetch
//     await Future.delayed(Duration(milliseconds: 1000));
//     HomeFragmentBody.selectednew?
//     hitGetHomeNewDataApi():
//     hitGetHomeTrendingDataApi();
//     _refreshController.refreshCompleted();
//   }
//   void _onLoading() async{
//     _refreshController.loadComplete();
//   }
// }
