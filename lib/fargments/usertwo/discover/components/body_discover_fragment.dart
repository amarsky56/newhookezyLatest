import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/userthree/profile/screen_profile_userthree.dart';
import 'package:hookezy/fargments/usertwo/view_user/components/body_viewuser.dart';
import 'package:hookezy/s/model/discover_list_model.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/helper.dart';

class DiscoverFragmentBody extends StatefulWidget {



  @override
  _DiscoverFragmentBodyState createState() => _DiscoverFragmentBodyState();
}

class _DiscoverFragmentBodyState extends State<DiscoverFragmentBody> {
  List<String> widgetList = ['A', 'B', 'C','c','A', 'B', 'C','c','r'];

  DiscoverListModel discoverListModel;
  bool isError = false;
  bool isLoading = true;
  Size size;
  double itemHeight;
  double itemWidth;
  String defaultLanguage;
  GetUserProfileModel getUserProfileModel;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 3.0;
    itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: pink,
        title: Text("Discover",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: uiPayload(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchDiscover();
    super.initState();
  }

  void fetchDiscover(){
    setState(() {
      isLoading = true;
      isError = false;
    });
    ApiRepository.getUserProfile(1).then((value) {
      setState(() {
        defaultLanguage = value.details.defaultLanguage;
        getUserProfileModel = value;
      });
      return ApiRepository.getDiscover(defaultLanguage);
    }).then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        discoverListModel = value;
      });
    }).catchError((error){
      print("discover error ${error}");
      setState(() {
        isLoading = false;
        isError = true;
        discoverListModel = null;
      });
    });
  }


  void fetchRefreshDiscover(String language){
    setState(() {
      isLoading = true;
      isError = false;
    });
    ApiRepository.getDiscover(language).then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        discoverListModel = value;
      });
    }).catchError((error){
      print("${error}");
      setState(() {
        isLoading = false;
        isError = true;
        discoverListModel = null;
      });
    });
  }

  Widget uiPayload() {
    if(isError){
      return ErrorScreen(onRefresh: (){ return fetchDiscover();},);
    }else if(isLoading){
      return ProgressLoader(title: "Fetching Data...",);
    }else{
      return Padding(
        padding: const EdgeInsets.only(top:16.0,left: 5.0,right: 5.0),
        child: Column(
          children: [
            Container(
              width: size.width,
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,position){
                  return Padding(
                    padding: const EdgeInsets.only(right: 18.0,),
                    child: GestureDetector(
                      onTap: (){
                        return fetchRefreshDiscover(discoverListModel.languageArr[position].language);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.yellow,
                            border: Border.all(color: Colors.grey,width: 1)
                        ),

                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0,right: 8),
                            child: Text("${discoverListModel.languageArr[position].language}",
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: discoverListModel.languageArr.length,),
            ),
            SizedBox(height: 10,),
            Expanded(
                child: Container(
                  child: discoverListModel.discoverArr.isNotEmpty ? listview() : Container(child: Center(child: Text("No Data Available"),),),
                ))
          ],
        ),
      );
    }
  }

  Widget listview() => GridView.builder(
    itemCount: discoverListModel.discoverArr.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: (itemWidth / itemHeight)),
    controller: ScrollController(keepScrollOffset: false),
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemBuilder: (context,index){
      return gridBody(discoverListModel.discoverArr[index]);
    },
  );

  Widget gridBody(DiscoverArr discoverArr) => GestureDetector(
    onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewUserBody(id: discoverArr.id,)));
    },
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                  color: Colors.black),
              borderRadius:
              BorderRadius.circular(8.0),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("${discoverArr.image}")
              )

          ),
          margin: new EdgeInsets.all(3.0),

        ),
        Positioned(
          bottom: 20,
          child: Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: Row(
              children: [
                Container(
                  height: size.height/68,
                  width: size.height/68,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.green
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text("${discoverArr.name}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),)
              ],
            ),
          ),
        )
      ],
    ),
  );

}
