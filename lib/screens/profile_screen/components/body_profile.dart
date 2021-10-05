import 'package:flutter/material.dart';
import 'package:hookezy/screens/profile_screen/components/background_profile.dart';

import '../../../constants.dart';

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final _formKey = GlobalKey<FormState>();
  final verifyotpcontroller = TextEditingController();
  bool _autoValidate = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff576a4),
        title: Text("Edit Profile",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'comfortaa_semibold'
            )
        ),
      ),
      body: ProfileBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: size.height * 0.10,
                      width: size.height * 0.10,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100),),
                              color: Color(0xff282A39),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLUU4RH0MQoXrtxXHncCFi3H6S9saN_i49lQ&usqp=CAU")
                              )
                            ),

                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: size.height * 0.04,
                              width: size.height * 0.04,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(32),
                                  ), color: Color(0xff393B49)
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: (){
                                    //openPicGallery();
                                  },
                                  child: Container(
                                    height: size.height * 0.02,
                                    width: size.height * 0.02,
                                    child: Image.asset("assets/icons/penicon.png"),),
                                ),
                              ),
                            ),
                          )
                        ], ),
                    ),
                  ),


                  SizedBox(height: size.height * 0.05),
                  Text("NAME",
                    style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: pink,
                        fontFamily: 'comfortaa_semibold'
                    ),),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffE5E5E5),
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white
                      ),
                      decoration:
                      new InputDecoration.collapsed(),
                      //controller: nameController,
                      //focusNode: _name,
                      /*onFieldSubmitted: (term) {
                        _name.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_username);
                      },*/
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                  ),



                  SizedBox(height: size.height * 0.05),
                  Text("ABOUT ME",
                    style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: pink,
                        fontFamily: 'comfortaa_semibold'
                    ),),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffE5E5E5),
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                      decoration:
                      new InputDecoration.collapsed(),
                      //controller: nameController,
                      //focusNode: _name,
                      /*onFieldSubmitted: (term) {
                        _name.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_username);
                      },*/
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                  ),





                  SizedBox(height: size.height * 0.05),
                  Text("AGE",
                    style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: pink,
                        fontFamily: 'comfortaa_semibold'
                    ),),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffE5E5E5),
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                      decoration:
                      new InputDecoration.collapsed(),
                      //controller: nameController,
                      //focusNode: _name,
                      /*onFieldSubmitted: (term) {
                        _name.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_username);
                      },*/
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                  ),


                  SizedBox(height: size.height * 0.05),
                  Text("JOB TITLE",
                    style: TextStyle(
                        fontSize: 11.0,
                        color: pink,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'comfortaa_semibold'
                    ),),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffE5E5E5),
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                      decoration:
                      new InputDecoration.collapsed(),
                      //controller: nameController,
                      //focusNode: _name,
                      /*onFieldSubmitted: (term) {
                        _name.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_username);
                      },*/
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                  ),







                  SizedBox(height: size.height * 0.05),
                  Text("COMPANY",
                    style: TextStyle(
                        fontSize: 11.0,
                        color: pink,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'comfortaa_semibold'
                    ),),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffE5E5E5),
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                      decoration:
                      new InputDecoration.collapsed(),
                      //controller: nameController,
                      //focusNode: _name,
                      /*onFieldSubmitted: (term) {
                        _name.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_username);
                      },*/
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),
                  Text("EDUCATION",
                    style: TextStyle(
                        fontSize: 11.0,
                        color: pink,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'comfortaa_semibold'
                    ),),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffE5E5E5),
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                      decoration:
                      new InputDecoration.collapsed(),
                      //controller: nameController,
                      //focusNode: _name,
                      /*onFieldSubmitted: (term) {
                        _name.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_username);
                      },*/
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                  ),



                  SizedBox(height: size.height * 0.05),
                  Text("ID",
                    style: TextStyle(
                        fontSize: 11.0,
                        color: pink,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'comfortaa_semibold'
                    ),),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffE5E5E5),
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                      decoration:
                      new InputDecoration.collapsed(),
                      //controller: nameController,
                      //focusNode: _name,
                      /*onFieldSubmitted: (term) {
                        _name.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_username);
                      },*/
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
