// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:hookezy/fargments/userone/edit_profile/screen.dart';
// import 'package:hookezy/fargments/userone/setting/setting_screen.dart';
// import 'package:hookezy/s/model/get_user_profile_model.dart';
// import 'package:hookezy/s/model/user_profile_data.dart';
// import 'package:hookezy/s/network.dart';
// import 'package:hookezy/s/utils/app.dart';
// import 'package:hookezy/s/utils/helper.dart';
// import 'package:hookezy/s/utils/stories.dart';
// import 'package:hookezy/s/utils/story_Detail.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:route_observer_mixin/route_observer_mixin.dart';
//
// import '../../../../constants.dart';
//
// class ViewUserBodyTwo extends StatefulWidget{
//   @override
//   _ViewUserBodyTwoState createState() => _ViewUserBodyTwoState();
// }
//
// class _ViewUserBodyTwoState extends State<ViewUserBodyTwo>  with RouteAware, RouteObserverMixin{
//   List<String> widgetList = ['A', 'B'];
//
//   bool isLoading = true;
//   bool isError = false;
//   bool isPhotosLoad = false;
//   UserProfileData userProfileData;
//   File selectedFile;
//   final picker = ImagePicker();
//   GetUserProfileModel getUserProfileModel;
//   final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
//
//
//
//   void fetchUserData(){
//     ApiRepository.getUserProfileData(1).then((value) {
//       setState(() {
//         //isLoading = false;
//         //isError = false;
//         isPhotosLoad = true;
//         userProfileData = value;
//       });
//     }).catchError((error){
//       setState(() {
//         //isLoading = false;
//         //isError = true;
//         isPhotosLoad = true;
//         userProfileData = null;
//       });
//     });
//   }
//
//
//   void fetUserProfile(){
//     ApiRepository.getUserProfile(1).then((value) {
//       setState(() {
//         isLoading = false;
//         isError = false;
//         getUserProfileModel = value;
//       });
//     }).catchError((error){
//       setState(() {
//         isLoading = false;
//         isError = true;
//         getUserProfileModel = null;
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     fetUserProfile();
//     fetchUserData();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final double itemHeight = (size.height - kToolbarHeight - 24) / 3.5;
//     final double itemWidth = size.width / 2;
//     return Scaffold(
//       appBar: AppBar(
//         //automaticallyImplyLeading: false,
//         backgroundColor: pink,
//         title: Text(
//           "ViewUser",
//           style: TextStyle(
//               color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           /*Padding(
//               padding: const EdgeInsets.only(right:8.0),
//               child: GestureDetector(
//                 onTap: (){
//                   showOptions();
//                 },
//                 child: Icon(Icons.shield,
//                   size: 24,
//                   color: Colors.white,),
//               ),
//             )*/
//         ],
//       ),
//       body: isLoading == true ? ProgressLoader(title: "Fetching data",) : SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 child: Column(
//                   children: [
//                     Row(
//                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Container(
//                         //   height: MediaQuery.of(context).size.height * 0.132,
//                         //   width: MediaQuery.of(context).size.height * 0.132,
//                         //   decoration: BoxDecoration(
//                         //       image: DecorationImage(
//                         //           image: NetworkImage(
//                         //               "${getUserProfileModel.details.image}"),
//                         //           fit: BoxFit.fill),
//                         //       color: Color(0xff282A39),
//                         //       border: Border.all(width: 1, color: Colors.black),
//                         //       borderRadius: BorderRadius.all(
//                         //         Radius.circular(100),
//                         //       )),
//                         //   child: Padding(
//                         //     padding: EdgeInsets.all(10),
//                         //   ),
//                         // ),
//                         Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             height: MediaQuery.of(context).size.height * 0.132,
//                             width: MediaQuery.of(context).size.height * 0.132,
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   height: MediaQuery.of(context).size.height * 0.132,
//                                   width: MediaQuery.of(context).size.height * 0.132,
//                                   decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                           image: NetworkImage(
//                                               "${getUserProfileModel.details.image}"),
//                                           fit: BoxFit.fill),
//                                       color: Color(0xff282A39),
//                                       border: Border.all(width: 1, color: Colors.black),
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(100),
//                                       )
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(10),
//                                     child: SNetWorkImage(
//                                       height: MediaQuery.of(context).size.height * 0.132,
//                                       width: MediaQuery.of(context).size.height * 0.132,
//                                       url: getUserProfileModel.details.image,
//                                     ),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: Container(
//                                     height: size.height * 0.04,
//                                     width: size.height * 0.04,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(32),
//                                         ), color: Color(0xff393B49)
//                                     ),
//                                     child: Center(
//                                       child: GestureDetector(
//                                         onTap: (){
//                                           //openPicGallery();
//                                           Navigator.push(context,
//                                               MaterialPageRoute(builder: (context) => UseroneProfileScreen()));
//                                         },
//                                         child: Container(
//                                           height: size.height * 0.02,
//                                           width: size.height * 0.02,
//                                           child: Image.asset("assets/icons/penicon.png"),),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ], ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "${getUserProfileModel.name}",
//                                 style: TextStyle(
//                                     fontSize: 15.0,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'comfortaa_semibold'),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 "${getUserProfileModel.details.country}",
//                                 style: TextStyle(
//                                     fontSize: 14.0,
//                                     fontFamily: 'comfortaa_semibold'),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               InkWell(
//                                   onTap: () {
//                                     /* if (_formKey.currentState.validate()) {
//                                 hitLoginApi();
//                               } else {
//                                 setState(() {
//                                   _autoValidate = true;
//                                 });
//                               }*/
//                                   },
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   UseroneProfileScreen()));
//                                     },
//                                     child: Container(
//                                       height: 35,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                           BorderRadius.circular(32),
//                                           border: Border.all(
//                                               color: Color(0xffFD6296),
//                                               width: 1)),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.edit,
//                                             color: Colors.grey,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text("Edit Profile",
//                                               style: TextStyle(
//                                                   fontFamily:
//                                                   'comfortaa_semibold',
//                                                   fontSize: 18,
//                                                   color: Color(0xffFD6296))),
//                                         ],
//                                       ),
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Text("${getUserProfileModel.details.about}"),
//               SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.videocam,
//                     size: 32,
//                     color: Colors.grey,
//                   ),
//                   Text(
//                     "Stories:",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               //UserStoriesTwo(),
//               UserStories(storyList: userProfileData.stories,),
//               //Home(),
//               SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.photo,
//                     size: 28,
//                     color: Colors.grey,
//                   ),
//                   Text(
//                     "Photos:",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 11,
//               ),
//               // GridView.count(
//               //   crossAxisCount: 2,
//               //   childAspectRatio: (itemWidth / itemHeight),
//               //   controller: ScrollController(keepScrollOffset: false),
//               //   shrinkWrap: true,
//               //   scrollDirection: Axis.vertical,
//               //   children: widgetList.map((String value) {
//               //     return Stack(
//               //       children: [
//               //         Container(
//               //           decoration: BoxDecoration(
//               //               border: Border.all(color: Colors.black),
//               //               borderRadius: BorderRadius.circular(8.0),
//               //               image: DecorationImage(
//               //                   fit: BoxFit.fill,
//               //                   image: NetworkImage(
//               //                       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLUU4RH0MQoXrtxXHncCFi3H6S9saN_i49lQ&usqp=CAU"))),
//               //           margin: new EdgeInsets.all(3.0),
//               //         ),
//               //       ],
//               //     );
//               //   }).toList(),
//               // ),
//               if(isPhotosLoad)showGrid()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget showGrid(){
//     if(userProfileData.photos.length > 0){
//       return GridView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//           itemCount: userProfileData.photos.length,
//           itemBuilder: (context,index){
//             return index == 0 ? PostAddButton(
//               onClick: (){
//                 getImage(ImageSource.gallery);
//               },
//             ) : Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black),
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               margin: new EdgeInsets.all(3.0),
//               child: SNetWorkImage(height: 80,width: MediaQuery.of(context).size.width * 0.50,url: userProfileData.photos[index].media,),
//             );
//           });
//     }else{
//       return GridView(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//         children: [
//           PostAddButton(
//             onClick: (){
//               getImage(ImageSource.gallery);
//             },
//           )
//         ],
//       );
//     }
//   }
//
//   void showOptions() {
//     showModalBottomSheet<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                     blurRadius: 10, color: Colors.grey[900], spreadRadius: 5)
//               ],
//               color: Colors.grey,
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//             ),
//             height: MediaQuery.of(context).size.height / 3,
//             width: MediaQuery.of(context).size.width - 20,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height / 15,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Block and Report",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontFamily: 'comfortaa_semibold'),
//                         ),
//                         Text(
//                           "What's the problem?",
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white,
//                               fontFamily: 'comfortaa_semibold'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: .3,
//                   color: Colors.white,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height / 17,
//                     color: Colors.pinkAccent,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Harassment",
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: .3,
//                   color: Colors.grey,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height / 17,
//                     color: Colors.pinkAccent,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Nudity",
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: .3,
//                   color: Colors.grey,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height / 17,
//                     color: Colors.pinkAccent,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "False Gender",
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: .3,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//           );
//         });
//   }
//
//   Future getImage(ImageSource imageSource) async {
//     final pickedFile = await picker.getImage(source: imageSource);
//     if(pickedFile != null){
//
//       setState(() {
//         selectedFile = File(pickedFile.path);
//       });
//       //Navigator.pop(context);
//       _settingModalBottomSheet();
//     }
//   }
//
//   void _settingModalBottomSheet() {
//     showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         builder: (BuildContext bc) {
//           return Container(
//               margin: EdgeInsets.only(top: 40.0),
//               child: ImagePreviewPost(file: selectedFile,));
//         });
//   }
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     //print("i am data");
//     //fetchUserData();
//     routeObserver.subscribe(this, ModalRoute.of(context));
//     super.didChangeDependencies();
//   }
//
//   @override
//   void didPopNext() {
//     // TODO: implement didPopNext
//     print("i am da");
//     fetUserProfile();
//     fetchUserData();
//     super.didPopNext();
//   }
//
//   @override
//   void didPush() { print("familyy push"); }
//
//   /// Called when the current route has been popped off.
//   @override
//   void didPop() { print("familyy pop");}
//
//   /// Called when a new route has been pushed, and the current route is no
//   /// longer visible.
//   @override
//   void didPushNext(){
//   }
// }
