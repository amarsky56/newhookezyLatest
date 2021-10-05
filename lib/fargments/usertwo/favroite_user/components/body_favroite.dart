import 'package:flutter/material.dart';

import '../../../../constants.dart';

class FavroiteBody extends StatefulWidget {
  @override
  _FavroiteBodyState createState() => _FavroiteBodyState();
}

class _FavroiteBodyState extends State<FavroiteBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: pink,
        title: Text("Favroite Users",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
                child: Container(
                  child: ListView.builder(
                    itemBuilder: (context, positon) {
                      return Column(
                        children: [
                          Container(
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
                                            "Country Name",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff999999)
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                 Text("REMOVE",
                                 style: TextStyle(
                                     fontSize: 12,
                                     color: Colors.grey,
                                     fontWeight: FontWeight.bold
                                 ),)
                                ],
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
