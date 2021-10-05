import 'package:flutter/material.dart';
import 'package:hookezy/fargments/usertwo/call/components/call_body.dart';
class CallFragmentScreen extends StatefulWidget {
  @override
  _CallFragmentScreenState createState() => _CallFragmentScreenState();
}

class _CallFragmentScreenState extends State<CallFragmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CallFragmentBody(),
    );
  }
}
