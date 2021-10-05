import 'package:flutter/material.dart';

class FinalStepBackground extends StatelessWidget {

  final Widget child;
  const FinalStepBackground({
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
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xfff576a4),
                    Color(0xfff576a4)
                  ],
                )
            ),
          ),
          child
        ],
      ),
    );
  }
}
