import 'package:flutter/material.dart';
import 'package:hookezy/screens/ask_gender/components/body_ask_gender.dart';

class AskgenderScreen extends StatefulWidget {
  String name;
  AskgenderScreen({
    this.name
  });
  @override
  _AskgenderScreenState createState() => _AskgenderScreenState();
}

class _AskgenderScreenState extends State<AskgenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AskgenderBody(name: widget.name,),
    );
  }
}
