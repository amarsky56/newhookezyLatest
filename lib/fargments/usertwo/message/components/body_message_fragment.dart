import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/usertwo/view_user/screen_viewuser.dart';

class MessageFragmentBody extends StatefulWidget {
  @override
  _MessageFragmentBodyState createState() => _MessageFragmentBodyState();
}

class _MessageFragmentBodyState extends State<MessageFragmentBody> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: pink,
        title: Text("Message",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CONVERSATION HISTORY",
            style: TextStyle(
              color: Color(0xffEC407A),
              fontSize: 16
            ),),
            SizedBox(
              height: 8,
            ),
            Container(
              width: size.width,
              height: size.height/4,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,position){
                return Padding(
                  padding: const EdgeInsets.only(right: 18.0,),
                  child: Stack(
                    children: [
                      Container(
                        width:size.width/3.1,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black),
                            borderRadius:
                            BorderRadius.circular(8.0),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLUU4RH0MQoXrtxXHncCFi3H6S9saN_i49lQ&usqp=CAU")
                            )

                        ),
                        margin: new EdgeInsets.all(0.0),

                      ),
                      Positioned(
                        bottom: 1,
                        left: 1,
                        right: 1,
                        child: Container(
                          width: size.width/3.1,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Colors.grey
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left:10.0),
                            child: Text("Username",
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                          ),
                        ),
                      )
                    ],
                  )
                );
              },
              itemCount: 4,),
            ),
            SizedBox(height: 10,),
            Text("MESSAGES",
              style: TextStyle(
                  color: Color(0xffEC407A),
                  fontSize: 16
              ),),
            SizedBox(
              height: 8,
            ),
            Expanded(
                child: Container(
              child: ListView.builder(
                itemBuilder: (context, positon) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap:(){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewUserScreen())
                    ) ;
                  },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6),),
                            color: Color(0xffe5e5e5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [

                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          color: Color(0xff282A39),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLUU4RH0MQoXrtxXHncCFi3H6S9saN_i49lQ&usqp=CAU"))
                                        //color: Colors.red,
                                      ),
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Username",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Hey..",
                                          style: TextStyle(
                                              fontSize: 12,
                                            color: Color(0xff999999)
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: kPrimaryColor
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  );
                },
                itemCount: 12,
              ),
            )
            )
          ],
        ),
      ),
    );
  }
}
