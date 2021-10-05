import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/usertwo/call/call_screen.dart';
import 'package:hookezy/fargments/usertwo/discover/screen_discover_fragment.dart';
import 'package:hookezy/fargments/usertwo/message/screen_message_fragment.dart';
import 'package:hookezy/fargments/usertwo/profile/screen_profile_fragment.dart';

class UserTwoBody extends StatefulWidget {
  static int currentindex =0 ;
  @override
  _UserTwoBodyState createState() => _UserTwoBodyState();
}

class _UserTwoBodyState extends State<UserTwoBody> {

  final tabs =[
    CallFragmentScreen(),
    DiscoverScreenFragment(),
    MessageFragmentScreen(),
    ProfileFragmentScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            //unselectedItemColor: Colors.white,
/*            showSelectedLabels: false,   // <-- HERE
            showUnselectedLabels: false,*/
            backgroundColor: Color(0xffFFFCFC),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/bottomicons/call.png"),),
                title: Text('Call'),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/bottomicons/discover.png"),),
                title: Text('Discover'),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/bottomicons/chat.png"),),
                title: Text('Messages'),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/bottomicons/profile.png"),),
                title: Text('Profile'),
              ),

            ],
            currentIndex: UserTwoBody.currentindex,
            selectedItemColor: pink,
            /* currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,*/
            onTap: (index) {
              //Handle button tap
              setState(() {
                UserTwoBody.currentindex = index;
              });
            }
        ),
        body: tabs[UserTwoBody.currentindex]
    );
  }
}
