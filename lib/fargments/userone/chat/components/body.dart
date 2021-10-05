import 'package:flutter/material.dart';
import 'package:hookezy/fargments/userone/chat/components/background.dart';


class UseroneChatBody extends StatefulWidget {
  @override
  _UseroneChatBodyState createState() => _UseroneChatBodyState();
}

class _UseroneChatBodyState extends State<UseroneChatBody> {
  final textcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      /* Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewUserScreen(id: widget.id)));*/
                    },
                    child: Container(
                      height: 45,
                      width: 50,
                      child: Stack(
                        //alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLUU4RH0MQoXrtxXHncCFi3H6S9saN_i49lQ&usqp=CAU"),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Positioned(
                            top: 28,
                            left: 36,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      /* Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewUserScreen(id: widget.id)));*/
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                              fontFamily: 'comfortaa_semibold', fontSize: 16),
                        ),
                        Text(
                          "Online",
                          style: TextStyle(
                              fontFamily: 'comfortaa_semibold', fontSize: 12),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: UseroneChatBackground(
            child: Container()
            /*Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    */ /*child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(0),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _chatBubble( index);
                      },
                    ),*/ /*

                    */ /*ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildSingleMessage(index);
                      },
                    )*/ /*
                  ),

                ),
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                    color:  Color(0xff2D2F36),
                    boxShadow: [ BoxShadow(
                      color: Colors.black,
                      blurRadius: 20.0,
                    ),]
                ),
                //height: MediaQuery.of(context).size.height*0.12,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 2,right: 2,top: 2,bottom: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            color:  Color(0xff2D2F36),
                            //shape: BoxShape.circle,
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            boxShadow: [ BoxShadow(
                              color: Colors.black,
                              blurRadius: 20.0,
                            ),]
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 14,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: InkWell(
                                    onTap: (){

                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,

                                      child: Container(
                                          height:8,
                                          width:8,
                                          child: Icon(Icons.camera_alt,
                                            color: Colors.white,)
                                      ),
                                    ),
                                  ),
                                ),
                                //color: Colors.white,
                              ),
                            ),
                            Expanded(
                              flex: 82,
                              child: Container(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(

                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: TextFormField(
                                            maxLines: null,
                                            controller: messageController,
                                            style: TextStyle(color: Colors.white),
                                            decoration:
                                            new InputDecoration.collapsed(
                                              hintText: 'Message...',
                                              hintStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'comfortaa_semibold',
                                                  color: Colors.white),
                                            ),
                                            //controller: passwordController,
                                            //focusNode: _password,
                                            // style: TextStyle(color: Color(0xff7AD530)),
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 12,
                              child: Container(

                                child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: InkWell(
                                    onTap: (){

                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,

                                      child: Container(
                                          height:10,
                                          width:10,
                                          child: Icon(Icons.image,
                                            color: Colors.white,)
                                      ),
                                    ),
                                  ),
                                ),
                                //color: Colors.white,
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: InkWell(
                                    onTap: (){
                                      //Check if the textfield has text or not
                                      if (messageController.text.isNotEmpty) {
                                        MyHomePage.socketIO.sendMessage('chat-msg', json.encode(
                                            {
                                              "msg":messageController.text,
                                              "msgTo": widget.receiver*/ /*"emmie"*/ /*,

                                              "date": selectedDate.toString().substring(0,10),
                                              "receiver": widget.receiver*/ /*"emmie"*/ /*
                                            }
                                        ));
                                        messageController.text = '';
                                      }
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color:  Color(0xff2D2F36),
                                          shape: BoxShape.circle,
                                          //borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                          boxShadow: [ BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 20.0,
                                          ),]
                                      ),
                                      child: Container(
                                          height:10,
                                          width:10,
                                          child: Center(
                                            child: Icon(Icons.send,
                                              color: Colors.white,),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                //color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ),
                //color: Color(0xff2D2F36),
              ),
            ],
          ),*/
            ),
      ),
    );
  }
}
