import 'dart:io';

import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:hookezy/s/model/user_profile_data.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/s/utils/story_Detail.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class UserStories extends StatefulWidget {
  List<Story> storyList;
  bool showAdd;

  UserStories({this.storyList,this.showAdd});

  @override
  _UserStoriesState createState() => _UserStoriesState();
}

class _UserStoriesState extends State<UserStories> with SingleTickerProviderStateMixin{

  /// Variables
  Animation gap;
  Animation base;
  Animation reverse;
  AnimationController controller;
  File selectedFile;
  final picker = ImagePicker();

  /// Init
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 4)
    );
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  String storyid,pagename,pageimage,pageid;
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(widget.showAdd)StoriesAddButton(
              onClick: (){
                getImage(ImageSource.gallery);
              },
            ),
            //SizedBox(width: 5.0,),
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, position) {
                print("my position is ${position}");
                return Padding(
                  padding: EdgeInsets.only(left: 5.0,right: 5.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryDetail(story: widget.storyList[position],)));
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
                          color: Color(0xff8A2BE2),
                          child: RotationTransition(
                            turns: reverse,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                    widget.storyList[position].storyMedia
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: widget.storyList.length ,

            )
          ],
        ),
      ),
    );
  }

  Map<String, Object> json;
  bool hitApi = false;
  static var userdetails;

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);
    if(pickedFile != null){

      setState(() {
        selectedFile = File(pickedFile.path);
      });
      //Navigator.pop(context);
      _settingModalBottomSheet();
    }
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.only(top: 40.0),
              child: ImagePreviewStory(file: selectedFile,));
        });
  }

}


class ImagePreviewStory extends StatefulWidget {

  File file;
  Object onClick;

  ImagePreviewStory({this.file});

  @override
  _ImagePreviewStoryState createState() => _ImagePreviewStoryState();
}

class _ImagePreviewStoryState extends State<ImagePreviewStory> {
  bool isLoad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Story"),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  postStor();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text("Post",style: TextStyle(fontSize: 20),),
                ),
              )
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //     color: Colors.white,
            //     image: DecorationImage(
            //         image: FileImage(widget.file),
            //         fit: BoxFit.fill
            //     )
            // ),
            //child: Image.file(file),
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.70,
                //width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: FileImage(widget.file),
                        fit: BoxFit.cover
                    )
                ),
                //child: Image.file(file),
              ),
            ),
          ),
          isLoad == true ? Container(child: Center(child: CircularProgressIndicator(),),) : Container()
        ],
      ),
    );
  }

  void postStor(){
    setState(() {
      isLoad = true;
    });
    ApiRepository.postStory(1, widget.file).then((value) {
      setState(() {
        isLoad = false;
      });
      //SHelper.showFlushBar("Story", "Story Posted", context);
      Navigator.pop(context);
    }).catchError((error){
      setState(() {
        isLoad = false;
      });
      Navigator.pop(context);
    });
  }
}



class ImagePreviewPost extends StatefulWidget {

  File file;
  Object onClick;

  ImagePreviewPost({this.file});

  @override
  _ImagePreviewPostState createState() => _ImagePreviewPostState();
}

class _ImagePreviewPostState extends State<ImagePreviewPost> {
  bool isLoad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Photos"),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  postStor();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text("Post",style: TextStyle(fontSize: 20),),
                ),
              )
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.70,
                //width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: FileImage(widget.file),
                        fit: BoxFit.fill
                    )
                ),
                //child: Image.file(file),
              ),
            ),
            //child: Image.file(file),
          ),
          isLoad == true ? Container(child: Center(child: CircularProgressIndicator(),),) : Container()
        ],
      ),
    );
  }

  void postStor(){
    setState(() {
      isLoad = true;
    });
    ApiRepository.postPhotos(1, widget.file).then((value) {
      setState(() {
        isLoad = false;
      });
      //SHelper.showFlushBar("Story", "Story Posted", context);
      Navigator.pop(context);
    }).catchError((error){
      setState(() {
        isLoad = false;
      });
      Navigator.pop(context);
    });
  }
}



