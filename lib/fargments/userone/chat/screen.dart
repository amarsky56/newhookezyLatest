import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userone/chat/components/body.dart';

class UseroneChatScreen extends StatefulWidget {
  @override
  _UseroneChatScreenState createState() => _UseroneChatScreenState();
}

class _UseroneChatScreenState extends State<UseroneChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UseroneChatBody(),
    );
  }
}
