import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';

class UserStories extends StatefulWidget {
  @override
  _UserStoriesState createState() => _UserStoriesState();
}

class _UserStoriesState extends State<UserStories> with SingleTickerProviderStateMixin{

  /// Variables
  Animation gap;
  Animation base;
  Animation reverse;
  AnimationController controller;

  /// Init
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 4));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  /// Dispose
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return InkWell(
            onTap:() async{

              //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            } ,
            child: Padding(
              padding: const EdgeInsets.only(right: 25.0,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context)  => StoryPageView()));
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      alignment: Alignment.center,
                      child: RotationTransition(
                        turns: base,
                        child: DashedCircle(
                          gapSize: gap.value,
                          dashes: 40,
                          color: Color(0XFFED4634),
                          child: RotationTransition(
                            turns: reverse,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                    "https://images.unsplash.com/photo-1564564295391-7f24f26f568b"
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text("Username",
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'comfortaa_semibold'
                    ),)
                ],
              ),
            ),
          );
        },
        itemCount: 7,

      ),
    );
  }
}
