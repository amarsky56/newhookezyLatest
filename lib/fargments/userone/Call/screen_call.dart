import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userone/Call/components/body_call.dart';

class CallScreenFragment extends StatefulWidget {
  @override
  _CallScreenFragmentState createState() => _CallScreenFragmentState();
}

class _CallScreenFragmentState extends State<CallScreenFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CallFragmentBody(),
    );
  }
}
