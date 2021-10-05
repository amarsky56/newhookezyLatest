import 'package:flutter/material.dart';
import 'package:hookezy/screens/final_step/components/body_final_step.dart';

class FinalStepScreen extends StatefulWidget {
  String name,gender;
  FinalStepScreen({
    this.name,this.gender
});

  @override
  _FinalStepScreenState createState() => _FinalStepScreenState();
}

class _FinalStepScreenState extends State<FinalStepScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FinalStepBody(name: widget.name,gender: widget.gender,),
    );
  }
}
