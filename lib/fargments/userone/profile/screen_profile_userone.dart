import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userone/profile/components/body_profile_userone.dart';

class ScreenUseroneProfile extends StatefulWidget {
  @override
  _ScreenUseroneProfileState createState() => _ScreenUseroneProfileState();
}

class _ScreenUseroneProfileState extends State<ScreenUseroneProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileFragmentUserone(),
    );
  }
}
