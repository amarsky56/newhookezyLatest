import 'package:flutter/material.dart';
import 'package:hookezy/fargments/usertwo/message/components/body_message_fragment.dart';

class MessageFragmentScreen extends StatefulWidget {
  @override
  _MessageFragmentScreenState createState() => _MessageFragmentScreenState();
}

class _MessageFragmentScreenState extends State<MessageFragmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MessageFragmentBody(),
    );
  }
}
