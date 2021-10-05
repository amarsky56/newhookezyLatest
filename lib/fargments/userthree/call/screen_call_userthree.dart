import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userthree/call/components/body_call_userthree.dart';

class CallScreenFragmentUserthree extends StatefulWidget {
  @override
  _CallScreenFragmentUserthreeState createState() => _CallScreenFragmentUserthreeState();
}

class _CallScreenFragmentUserthreeState extends State<CallScreenFragmentUserthree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CallFragmentBodyUserthree(),
    );
  }
}
