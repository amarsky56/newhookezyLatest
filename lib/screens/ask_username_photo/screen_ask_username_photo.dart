import 'package:flutter/material.dart';
import 'package:hookezy/screens/ask_username_photo/components/body_ask_username_photo.dart';


class AskUsernamePhotoScreen extends StatefulWidget {
  @override
  _AskUsernamePhotoScreenState createState() => _AskUsernamePhotoScreenState();
}

class _AskUsernamePhotoScreenState extends State<AskUsernamePhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AskUsernamePhotoBody(),
    );
  }


}
