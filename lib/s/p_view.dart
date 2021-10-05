import 'package:flutter/material.dart';
import 'package:hookezy/s/model/user_profile_data.dart';
import 'package:photo_view/photo_view.dart';

class PView extends StatefulWidget {

  List<Photo> photos;
  int index;

  PView({this.index,this.photos});

  @override
  _PViewState createState() => _PViewState();
}

class _PViewState extends State<PView> {

  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: PageView.builder(
            controller: pageController,
              itemCount: widget.photos.length,
              itemBuilder: (context,index){
                return PhotoView(
                  imageProvider: NetworkImage(widget.photos[index].media),
                );
              }),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController(
      initialPage: widget.index
    );
    super.initState();
  }
}
