import 'package:flutter/material.dart';

class UseroneProfileBackground extends StatelessWidget {
  final Widget child;
  const UseroneProfileBackground({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(

          ),
          child
        ],
      ),
    );
  }
}
