import 'package:flutter/material.dart';
import 'package:hookezy/screens/ask_gender/components/background_ask_gender.dart';
import 'package:hookezy/screens/final_step/final_step_screen.dart';

import '../../../constants.dart';

class AskgenderBody extends StatefulWidget {
  String name;
  AskgenderBody({
    this.name
  });
  @override
  _AskgenderBodyState createState() => _AskgenderBodyState();
}

class _AskgenderBodyState extends State<AskgenderBody> {
  static int selectedRadioTile;
  String sex;
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
      if(selectedRadioTile == 1){
        sex = "Female";
      }
      else
        sex = "Male";
    });
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AskGenderBackground(
        child: Padding(
          padding: EdgeInsets.only(left:16,right:16,top:16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height/35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width/3.4,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16),
                          ),
                          color: Color(0xffEC407A)
                      ),
                    ),
                    Container(
                      width: size.width/3.4,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16),
                          ),
                          color: Color(0xffEC407A)
                      ),
                    ),
                    Container(
                      width: size.width/3.4,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16),
                          ),
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.09,
                ),
                Container(
                  height: size.height * 0.12,
                  width: size.height * 0.12,
                  child: Image.asset("assets/images/gendericon.png"),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  "What is your gender?",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.00,
                ),
                Text(

                  "Make sure you picked your gender correctly. You won't be able to change this later. Unlike real line :)",

                    textAlign: TextAlign.center,
                  style: TextStyle(

                      color: Colors.white),
                ),
//CHOICE MALE OR FEMALE.........................................................
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Female',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontFamily: 'comfortaa_semibold'),
                        ),
                        Radio(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          value: 1,
                          groupValue: selectedRadioTile,
                          activeColor: kPrimaryColor,
                          onChanged: (val) {
                            print("Radio $val");
                            setSelectedRadioTile(val);

                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: Container(
                    height: 1,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Male',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontFamily: 'comfortaa_semibold'),
                        ),
                        Radio(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          value: 2,
                          groupValue: selectedRadioTile,
                          activeColor: kPrimaryColor,
                          onChanged: (val) {
                            print("Radio $val");
                            setSelectedRadioTile(val);

                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: Container(
                    height: 1,
                    color: Colors.white,
                  ),
                ),

                SizedBox(
                  height: size.height * 0.39,
                ),
                GestureDetector(
                  onTap: () {
                    showConfirmDialog();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        gradient: LinearGradient(
                          colors: [Color(0xffEC407A), Color(0xffFD6296)],
                        )),
                    child: Center(
                      child: Text(
                        "CONTINUE",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  void showConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Align(
            child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                backgroundColor: Colors.transparent,
                content: Wrap(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                        ),
                        child:Column(
                          children: <Widget>[
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16)),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      kPrimaryLightColor,
                                      kPrimaryColor,
                                    ],
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Please Confirm Your Gender",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Have you selected correct gender? You won't be able to change that afterwards.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  "You selected "+sex,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xffec407a)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:10,right:10),
                                        child: Center(
                                            child: Text(
                                              "BACK",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'comfortaa_semibold',
                                                fontSize: 18,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                                      => FinalStepScreen(name: widget.name,gender: sex,)));
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xffec407a)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:10,right:10),
                                        child: Center(
                                            child: Text(
                                              "CONTINUE",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'comfortaa_semibold',
                                                fontSize: 18,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                          ],
                        )),
                  ],
                )),
          );
        });
  }
}
