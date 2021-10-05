import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userthree/leader/components/body_leader_userthree.dart';

class LeaderScreenUserthree extends StatefulWidget {
  @override
  _LeaderScreenUserthreeState createState() => _LeaderScreenUserthreeState();
}

class _LeaderScreenUserthreeState extends State<LeaderScreenUserthree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LeaderBodyUserthree(),
    );
  }
}
