import 'package:flutter/material.dart';
import 'package:hookezy/screens/searching/components/body_searching.dart';

class SearchingScreen extends StatefulWidget {
  int mychoice;
  SearchingScreen({
  this.mychoice
  });
  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchingBody(mychoice:widget.mychoice),
    );
  }
}
