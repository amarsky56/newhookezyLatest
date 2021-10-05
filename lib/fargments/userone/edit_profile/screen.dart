import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userone/edit_profile/components/body.dart';
import 'package:hookezy/screens/profile_screen/components/body_profile.dart';

class UseroneProfileScreen extends StatefulWidget {
  @override
  _UseroneProfileScreenState createState() => _UseroneProfileScreenState();
}

class _UseroneProfileScreenState extends State<UseroneProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UseroneProfileBody(),
    );
  }
}
