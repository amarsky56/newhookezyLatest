import 'package:flutter/material.dart';
import 'package:hookezy/fargments/usertwo/profile/components/body_profile_fragment.dart';

class ProfileFragmentScreen extends StatefulWidget {
  @override
  _ProfileFragmentScreenState createState() => _ProfileFragmentScreenState();
}

class _ProfileFragmentScreenState extends State<ProfileFragmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileFragmentBody(),
    );
  }
}
