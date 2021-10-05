import 'package:flutter/material.dart';
import 'package:hookezy/s/model/my_earning_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/helper.dart';


class MyEarning extends StatefulWidget {
  @override
  _MyEarningState createState() => _MyEarningState();
}

class _MyEarningState extends State<MyEarning> {

  MyEarningModel myEarningModel;

  bool isError = false;
  bool isLoading = true;

  bool hours = true;
  BoxDecoration pinkdecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      gradient: LinearGradient(
        colors: [Color(0xffEC407A), Color(0xffFD6296)],
      ));
  TextStyle whitedecoration = TextStyle(color: Colors.white);

  TextStyle greydecoration = TextStyle(color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("My Earning"),
      ),
      body: uiPaylod(),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    getMyEarning();
    super.initState();
  }

  void getMyEarning(){
    ApiRepository.getMyEarning(AppConstant.DEFAULT_USER_ID).then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        myEarningModel = value;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
        isError = true;
        myEarningModel = null;
      });
    });
  }

  Widget uiPaylod(){
    if(isError){
      return ErrorScreen(onRefresh: (){
        getMyEarning();
      },);
    }else if(isLoading == true){
      return ProgressLoader(title: "Fetching Data...",);
    }else{
      return _body();
    }
  }


  Widget _body() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 50,
        margin: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  hours = true;
                });
              },
              child: Container(
                  height: 40,

                  width: MediaQuery.of(context).size.width * 0.40,
                  decoration: hours
                      ? pinkdecoration
                      : BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Center(
                        child: Text(
                          "Last 24 Hours",
                          style: hours ? whitedecoration : greydecoration,
                        )),
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  hours = false;
                });
              },
              child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.40,
                  decoration: hours
                      ? BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.grey)):pinkdecoration,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Center(
                        child: Text(
                          "This Week",
                          style: hours ?greydecoration:whitedecoration,
                        )),
                  )),
            ),
          ],
        ),
      ),

      Container(
        width: MediaQuery.of(context).size.width,

        margin: EdgeInsets.only(left: 10.0,right: 10.0,top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                  ),
                  child: Center(
                    child: Text("${myEarningModel.name.substring(0,1).toUpperCase()}",style: TextStyle(color: Colors.pink,fontSize: 20),),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${myEarningModel.name}"),
                      Text("${myEarningModel.email}")
                    ],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(right: 20.0),
            child: Row(
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
                  "${myEarningModel.coins}",
                  style: TextStyle(color: Colors.black,fontSize: 20.0),
                )
              ],
            ),)
          ],
        ),
      )
    ],
  );



}
