import 'package:flutter/material.dart';
import 'package:hookezy/screens/welcome/components/welcom_body.dart';
class WelcomeScreen extends StatefulWidget {
  static String baseurl = "http://13.127.44.197:4600/api/users/";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeBody(),
    );
  }
}
