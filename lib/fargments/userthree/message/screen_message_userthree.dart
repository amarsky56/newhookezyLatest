import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userthree/message/components/body_message_userthree.dart';

class MessageScreenUserthree extends StatefulWidget {
  @override
  _MessageScreenUserthreeState createState() => _MessageScreenUserthreeState();
}

class _MessageScreenUserthreeState extends State<MessageScreenUserthree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MessageBodyUserthree(),
    );
  }
}
