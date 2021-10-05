import 'dart:async';
import 'dart:io';


import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hookezy/s/utils/quick_blox_local.dart';
import 'package:hookezy/screens/general/general_screen.dart';
import 'package:hookezy/screens/welcome/welcome_screen.dart';
import 'package:ots/ots.dart';

import 'package:route_observer_mixin/route_observer_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_application/secure_application.dart';
import 'package:provider/provider.dart';


void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MultiProvider(
        providers: [
          // 1. Wrap MaterialApp with RouteObserverProvider.
          RouteObserverProvider(),
          //ChangeNotifierProvider(create: (context) => Logger())
        ],
        child: MyApp(),
      )
  );

}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return OTS(
      showNetworkUpdates: true,
      loader: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hookezy',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        navigatorObservers: [RouteObserverProvider.of(context)],
        home: SecureApplication(child: MyHomePage ()),
      ),
    );
  }

  @override
  void initState(){

    simpleInit();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void simpleInit(){
    try{
      QuickBloxLocal.init();
      //QuickBloxLocal.auth();
      //QuickBloxLocal.initVideoCall().then((value) {});
    }catch(error){
      print("alsaaaa ${error}");
    }
  }

}

class MyHomePage extends StatefulWidget {
  static bool createdpage = false;
  static String unique_id, device_type;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  bool session = false;


  @override
  void initState() {
    super.initState();

    _getId();
    getSharedPreferencesrences();


  }
  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      MyHomePage.device_type = "IOS"; // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      MyHomePage.unique_id = iosDeviceInfo.identifierForVendor; // unique ID on iOS
      debugPrint("IOS IS " + MyHomePage.unique_id + "   " + MyHomePage.device_type);
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      MyHomePage.unique_id = androidDeviceInfo.androidId; // unique ID on Android
      MyHomePage.device_type = "ANDROID";
      debugPrint("Android  IS " + MyHomePage.unique_id + "   " + MyHomePage.device_type);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if( MediaQuery.platformBrightnessOf(context) == Brightness.dark){
      debugPrint("DarkTheme");
    }
    else{
      debugPrint("LightTheme");
    }
    return
      Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff8e8e8e),
                      Color(0xff424242)
                    ],
                )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.32,
                width: size.height * 0.32,
                child: Image.asset("assets/images/hlogo.png"),
              ),
            ],
          )
        ],
      );
  }

  void getSharedPreferencesrences() async{

    SharedPreferences shref = await SharedPreferences.getInstance();
    bool session = shref.getBool("is_login");
    debugPrint("session is "+session.toString());
    if(session == true){
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()
          ));
    }
    else
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => WelcomeScreen()
          )
      );
  }
}
