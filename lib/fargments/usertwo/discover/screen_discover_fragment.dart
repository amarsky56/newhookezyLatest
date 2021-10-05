import 'package:flutter/material.dart';
import 'package:hookezy/fargments/usertwo/discover/components/body_discover_fragment.dart';

class DiscoverScreenFragment extends StatefulWidget {
  @override
  _DiscoverScreenFragmentState createState() => _DiscoverScreenFragmentState();
}

class _DiscoverScreenFragmentState extends State<DiscoverScreenFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DiscoverFragmentBody(),
    );
  }
}
