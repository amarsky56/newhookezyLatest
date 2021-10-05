import 'package:flutter/material.dart';
import 'package:hookezy/s/model/user_profile_data.dart';
import 'package:story_view/story_view.dart';

class StoryDetail extends StatelessWidget {
  final StoryController controller = StoryController();
  List<Story> storyList = [];
  Story story;


  StoryDetail({this.story});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(
          0,
        ),
        // child: ListView(
        //   children: <Widget>[
        //     Container(
        //       height: MediaQuery.of(context).size.height,
        //       child: ,
        //     ),
        //
        //   ],
        // ),

        child: Center(
          child: StoryView(
            controller: controller,
            storyItems: [
              // StoryItem.text(
              //   title:
              //   "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
              //   backgroundColor: Colors.orange,
              //   roundedTop: true,
              // ),
              // StoryItem.inlineImage(
              //   NetworkImage(
              //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
              //   caption: Text(
              //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
              //     style: TextStyle(
              //       color: Colors.white,
              //       backgroundColor: Colors.black54,
              //       fontSize: 17,
              //     ),
              //   ),
              // ),
              StoryItem.inlineImage(
                url:
                "${story.storyMedia}",

                imageFit: BoxFit.contain,
                controller: controller,
                // caption: Text(
                //   "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
                //   style: TextStyle(
                //     color: Colors.white,
                //     backgroundColor: Colors.black54,
                //     fontSize: 17,
                //   ),
                // ),
              ),
              // StoryItem.inlineImage(
              //   url:
              //   "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
              //   controller: controller,
              //   caption: Text(
              //     "Hektas, sektas and skatad",
              //     style: TextStyle(
              //       color: Colors.white,
              //       backgroundColor: Colors.black54,
              //       fontSize: 17,
              //     ),
              //   ),
              // )
            ],
            onStoryShow: (s) {
              print("Showing a story");
            },
            onComplete: () {
              Navigator.pop(context);
            },
            progressPosition: ProgressPosition.top,
            repeat: false,
            inline: true,
          ),
        ),

      ),
    );
  }
}

class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More"),
      ),
      body: StoryView(
        storyItems: [
          StoryItem.text(
            title: "I guess you'd love to see more of our food. That's great.",
            backgroundColor: Colors.blue,
          ),
          StoryItem.text(
            title: "Nice!\n\nTap to continue.",
            backgroundColor: Colors.red,
            textStyle: TextStyle(
              fontFamily: 'Dancing',
              fontSize: 40,
            ),
          ),
          StoryItem.pageImage(
            url:
            "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            caption: "Still sampling",
            controller: storyController,
          ),
          StoryItem.pageImage(
              url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
              caption: "Working with gifs",
              controller: storyController),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: "Hello, from the other side",
            controller: storyController,
          ),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: "Hello, from the other side2",
            controller: storyController,
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}

