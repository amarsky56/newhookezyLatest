import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hookezy/s/model/rest_countries_model.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProgressLoader extends StatelessWidget {

  String title;

  ProgressLoader({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(title)
          ],
        ),
      ),
    );
  }
}


class ErrorScreen extends StatelessWidget {

  Object onRefresh;

  ErrorScreen({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: onRefresh,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.refresh,size: 30,),
              Text("Unable to fetch data")
            ],
          ),
        ),
      ),
    );
  }
}


class SHelper {

  static Flushbar showFlushBar(String title,String message,BuildContext context) => Flushbar(
    title: title,
    backgroundColor: Colors.green,
    flushbarPosition: FlushbarPosition.TOP,
    message: message,
    duration: Duration(seconds: 4),
  )..show(context);

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userid");
  }

  static Future<String> getPremium() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userRole");
    //return prefs.getString("userRole") != null ? prefs.getBool("userRole") : false;
  }

  static Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userName");
  }

  static Future<int> getQuickBloxUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstant.QUICKBLOX_USERID_STORE_KEY);
  }

  static Future<String> returnUserRole() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String v = await getPremium();
    bool c = await prefs.getBool("isHost");
    print("${v} kolpppp");
    //String cc = c == true ? "Host" : "";
    return v;
    //return !c ? "Premium" : cc;
  }

}

class NotificationService{

  static final FirebaseMessaging firebaseMessaging =  FirebaseMessaging.instance;

  static Future<String> fetchDeviceToken() async {
    String uid = "asdjhsajk9847239";
    String fcmToken = await firebaseMessaging.getToken();
    print(fcmToken);
    if (fcmToken != null){
      return fcmToken;
    }
  }

}

class SSNetWorkImage extends StatelessWidget {
  double height,width;
  String url;
  SSNetWorkImage({this.height,this.width,this.url});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url != null ? url : "",
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(

          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(height: height,width: width,child: Center(child: Container(height: 20,width: 20,child: Center(child: CircularProgressIndicator(strokeWidth: 1.0,),),),),),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

class SNetWorkImage extends StatelessWidget {
  double height,width;
  String url;
  SNetWorkImage({this.height,this.width,this.url});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url != null ? url : "",
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => Container(height: height,width: width,child: Center(child: Container(height: 20,width: 20,child: Center(child: CircularProgressIndicator(strokeWidth: 1.0,),),),),),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}


class CountryChoiceField extends StatefulWidget {

  List<RestCountriesModel> restCountriesModelList;
  RestCountriesModel initialValue;
  Object onChanged;

  CountryChoiceField({this.restCountriesModelList,this.initialValue,this.onChanged});

  @override
  _CountryChoiceFieldState createState() => _CountryChoiceFieldState();
}

class _CountryChoiceFieldState extends State<CountryChoiceField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<RestCountriesModel>(
      //style: Theme.of(context).textTheme.headline1,
      value: widget.initialValue,
      //icon: Padding(padding: EdgeInsets.only(right: 5.0),child: Image.asset(icon,width: 14,height: 7,),),
      icon: Padding(
        padding: EdgeInsets.only(right: 5.0),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xff182C53),
        ),
      ),
      // validator: (value) {
      //   if (value == null) {
      //     return 'Required';
      //   }
      //   return null;
      // },
      onSaved: (value) {
        // ...
      },
      onChanged: widget.onChanged,
      // decoration: new InputDecoration(
      //   isDense: true,
      //   border: new OutlineInputBorder(
      //     borderRadius: BorderRadius.all(
      //         Radius.circular(15)),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.white),
      //       borderRadius: BorderRadius.all(
      //           Radius.circular(15.0))),
      //   hintText: "Choose Country",
      //   //hintStyle: Theme.of(context).textTheme.headline1,
      //   //icon: Icon(Icons.keyboard_arrow_down),
      //   //labelText: "Password",
      //   filled: true,
      //   fillColor: Color(0xffF2F4F9),
      //   //icon: Icon(Icons.keyboard_arrow_down)
      // ),
      items: widget.restCountriesModelList.map((RestCountriesModel countryModel) => new DropdownMenuItem<RestCountriesModel>(child: Text(countryModel.name),value: countryModel,)).toList(),

    );
  }
}


class StoriesAddButton extends StatelessWidget {

  Object onClick;

  StoriesAddButton({this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey
        ),
        child: Center(
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class PostAddButton extends StatelessWidget {

  Object onClick;

  PostAddButton({this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        //height: 60,
        //width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey
        ),
        margin: new EdgeInsets.all(3.0),
        child: Center(
          child: Icon(Icons.add,size: 80,),
        ),
      ),
    );
  }
}