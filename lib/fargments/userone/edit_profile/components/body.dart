import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/userone/edit_profile/components/background.dart';
import 'package:hookezy/model/fragments/userone/get_profile.dart';
import 'package:hookezy/model/fragments/userone/update_profile_info.dart';
import 'package:hookezy/model/fragments/userone/upload_picture.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/model/rest_countries_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/screens/profile_screen/components/background_profile.dart';
import 'package:hookezy/screens/welcome/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;



class UseroneProfileBody extends StatefulWidget {
  @override
  _UseroneProfileBodyState createState() => _UseroneProfileBodyState();
}

class _UseroneProfileBodyState extends State<UseroneProfileBody> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var aboutmeController = TextEditingController();
  var ageController = TextEditingController();
  var jobtitleController = TextEditingController();
  var companyController = TextEditingController();
  var educationController = TextEditingController();
  var idController = TextEditingController();
  List<RestCountriesModel> restCountriesModelList;
  bool _autoValidate = false;
  RestCountriesModel selectedCountry;
  bool picselected = false;
  File _profilepic;

  bool isError = false;
  bool isLoading = true;
  GetUserProfileModel getUserProfileModel;


  void fetchCountry(){
    ApiRepository.getCountries(1).then((value) {

    }).catchError((error){

    });
  }

  Future openPicGallery() async {
    // ignore: deprecated_member_use
    ImagePicker picker = ImagePicker();
    final picimage = await picker.getImage(
      source: ImageSource.gallery, imageQuality: 90,
    );
    setState(() {
      picselected = true;
      _profilepic = File(picimage.path);
      hitUpadteProfilePictureApi();
    });
  }

  bool hitApi = false;
  @override
  void initState() {
    super.initState();
    //hiitGetUserApi();
    getProfilePayload();
  }

  void getProfilePayload(){
    ApiRepository.getUserProfile(1).then((value) {
      setState(() {
        getUserProfileModel = value;
        nameController.text = value.name;
        aboutmeController.text = value.details.about;

        ageController.text = value.details.age;
        jobtitleController.text = value.details.jobtitle;
        companyController.text = value.details.company;
        educationController.text = value.details.education;
        idController.text = value.details.uniqueId;
      });
      return ApiRepository.getCountries(1);
    }).then((value) {
      setState(() {
        restCountriesModelList = value;
        isError = false;
        isLoading = false;

      });
    }).catchError((error){
      setState(() {
        getUserProfileModel = null;
        isError = true;
        isLoading = false;
      });
    });
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap:(){
                  //hitUpateInfoApi();
                  //print(selectedCountry.languages[0].name);
                  print(_formKey.currentState.validate());
                  if(_formKey.currentState.validate()){
                    //print(selectedCountry);
                    updateProfileS();
                  }

                },
                child: Icon(Icons.check,size: 25,color: Colors.white,)),
          )
        ],
      ),
      body: isLoading == true ? ProgressLoader(title: "Fetching Profile",) : UseroneProfileBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                                        image: picselected ?Image.file(_profilepic).image:
                                        NetworkImage(getUserProfileModel.details.image ==null?"":
                                        getUserProfileModel.details.image)
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
                                        openPicGallery();
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
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black
                            ),
                            decoration:
                            new InputDecoration.collapsed(),
                            validator: (value){
                              if(value.toString().length == 0){
                                return "This field is required";
                              }
                              return null;
                            },
                            controller: nameController,
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
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black
                            ),
                            decoration:
                            new InputDecoration.collapsed(),
                            controller: aboutmeController,
                            // validator: (value){
                            //   if(value.toString().length == 0){
                            //     return "This field is required";
                            //   }
                            //   return null;
                            // },
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
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black
                            ),
                            decoration:
                            new InputDecoration.collapsed(),
                            controller: ageController,
                            // validator: (value){
                            //   if(value.toString().length == 0){
                            //     return "This field is required";
                            //   }
                            //   return null;
                            // },
                            //focusNode: _name,
                            /*onFieldSubmitted: (term) {
                        _name.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_username);
                      },*/
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Text("COUNTRY",
                        style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: pink,
                            fontFamily: 'comfortaa_semibold'
                        ),),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xffE5E5E5),
                        height: 50,
                        child: Center(
                          child: CountryChoiceField(
                            initialValue: getUserProfileModel.details.country_index != null ? restCountriesModelList[getUserProfileModel.details.country_index] : null,
                            restCountriesModelList: restCountriesModelList,
                            onChanged: (value){
                              //print(value.);
                              setState(() {
                                selectedCountry = value;
                              });
                            },
                          ),
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
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black
                            ),
                            decoration:
                            new InputDecoration.collapsed(),
                            controller: jobtitleController,
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
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black
                            ),
                            decoration:
                            new InputDecoration.collapsed(),
                            controller: companyController,
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
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black
                            ),
                            // validator: (value){
                            //   if(value.toString().length == 0){
                            //     return "This field is required";
                            //   }
                            //   return null;
                            // },
                            decoration:
                            new InputDecoration.collapsed(),
                            controller: educationController,
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
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black
                            ),
                            enabled: false,

                            decoration:
                            new InputDecoration.collapsed(),
                            controller: idController,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),Visibility(
              visible: hitApi,
              child: Container(
                height: size.height,
                width: size.width,
                decoration:
                BoxDecoration(color: Colors.grey.withOpacity(.64)),
                child: Center(
                    child: SpinKitRipple(
                      color: Colors.pink,
                    )
                  /*AnimatedBuilder(
                          animation: animationController,
                          child:  Container(
                            height: 60.0,
                            width: 60.0,
                            child:  Image.asset('assets/images/hashsymbol.png'),
                          ),
                          builder: (BuildContext context, Widget _widget) {
                            return new Transform.rotate(
                              angle: animationController.value * 6.3,
                              child: _widget,
                            );
                          },
                        ),*/
                ),
              ),
            )
          ],
        )
      ),
    );
  }



  UpdateUserProfileModel getUpdateUserProfileModel() => UpdateUserProfileModel(
    id: 319,
    about: aboutmeController.text,
    age: ageController.text,
    jobtitle: jobtitleController.text != null ? jobtitleController.text : "",
    company: companyController.text != null ? companyController.text : "",
    country: selectedCountry != null ? selectedCountry.name : "",
    country_index: selectedCountry != null ? restCountriesModelList.indexWhere((element) => element.name == selectedCountry.name) : null,
    language: selectedCountry != null ? selectedCountry.languages[0].name : "",
    education: educationController.text != null ? educationController.text : "",
    uniqueId: idController.text,
    image: _profilepic

  );

  void updateProfileS(){
    setState(() {
      hitApi = true;
    });
    ApiRepository.updateUserProfile(getUpdateUserProfileModel()).then((value) {
      setState(() {
        hitApi = false;
      });
      SHelper.showFlushBar("Profile", "Profile Successfully updated", context);
    }).catchError((error){
      setState(() {
        hitApi = false;
      });
      SHelper.showFlushBar("Profile", "Unable to save changes", context);
    });
  }

  Future<UploadProfilePictuerApi> hitUpadteProfilePictureApi() async{

  }

  Map<String, Object> json;
  static var userdetails;

  Future<GetUserApi> hiitGetUserApi() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString("userid");
    debugPrint("mytoken is =" + userid);

    setState(() {
      hitApi = true;

    });

    Response response =
    await http.get(Uri.parse(WelcomeScreen.baseurl+"currentUser/"+userid));

    if(response.statusCode == 200){
      setState(() {
        hitApi = false;
      });

      userdetails = JSON.jsonDecode(response.body);

      debugPrint("RESPONSE IS ="+userdetails['isSuccess'].toString());
      if (userdetails['isSuccess'] == true) {
        nameController = TextEditingController(text: userdetails['data']['userName']);
        aboutmeController = TextEditingController(text: userdetails['data']['abouMe']);
        ageController = TextEditingController(text: userdetails['data']['age']);
        jobtitleController = TextEditingController(text: userdetails['data']['jobTitle']);
        companyController = TextEditingController(text: userdetails['data']['company']);
        idController = TextEditingController(text: userdetails['data']['_id']);
      }
    }
    else if(response.statusCode == 400){
      setState(() {
        hitApi = false;
        Toast.show(userdetails['status'], context);
        debugPrint(userdetails['message']);
      });
    }
  }


  Future<UpdateprofileInfoApi> hitUpateInfoApi() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString("userid");
    debugPrint("mytoken is =" + userid);

    setState(() {
      hitApi = true;
      json = {
        "abouMe": aboutmeController.text,
        "age": ageController.text,
        "jobTitle": jobtitleController.text,
        "company": companyController.text,
        "education": educationController.text,
        "ID": "",
      };
    });

    Response response =
    await http.get(Uri.parse(WelcomeScreen.baseurl+"update/"+userid));

    if(response.statusCode == 200){
      setState(() {
        hitApi = false;
      });

      userdetails = JSON.jsonDecode(response.body);

      debugPrint("RESPONSE IS ="+userdetails['isSuccess'].toString());
      if (userdetails['isSuccess'] == true) {
        nameController = TextEditingController(text: userdetails['data']['userName']);
        aboutmeController = TextEditingController(text: userdetails['data']['abouMe']);
        ageController = TextEditingController(text: userdetails['data']['age']);
        jobtitleController = TextEditingController(text: userdetails['data']['jobTitle']);
        companyController = TextEditingController(text: userdetails['data']['company']);
        idController = TextEditingController(text: userdetails['data']['_id']);
      }
    }
    else if(response.statusCode == 400){
      setState(() {
        hitApi = false;
        Toast.show(userdetails['status'], context);
        debugPrint(userdetails['message']);
      });
    }
  }
}
