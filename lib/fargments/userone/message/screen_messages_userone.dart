import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userone/message/components/body_message_userone.dart';

class UserOneMessageScreen extends StatefulWidget {
  @override
  _UserOneMessageScreenState createState() => _UserOneMessageScreenState();
}

class _UserOneMessageScreenState extends State<UserOneMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UseroneMessageBody(),
    );
  }
}
