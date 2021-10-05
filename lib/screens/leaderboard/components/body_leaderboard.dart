import 'package:flutter/material.dart';
import 'package:hookezy/constants.dart';
import 'package:hookezy/fargments/userthree/call/screen_call_userthree.dart';
import 'package:hookezy/fargments/userthree/leader/screen_leader_userthree.dart';
import 'package:hookezy/fargments/userthree/message/screen_message_userthree.dart';
import 'package:hookezy/fargments/userthree/profile/screen_profile_userthree.dart';

class ScreenLeaderboard extends StatefulWidget {
  static int currentindex =0 ;
  @override
  _ScreenLeaderboardState createState() => _ScreenLeaderboardState();
}

class _ScreenLeaderboardState extends State<ScreenLeaderboard> {
  final tabs =[
    CallScreenFragmentUserthree(),
    MessageScreenUserthree(),
    LeaderScreenUserthree(),
    ProfileScreenUserthree()
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
                  AssetImage("assets/bottomicons/chat.png"),),
                title: Text('Message'),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/bottomicons/leaderboard.png"),),
                title: Text('Leaders'),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/bottomicons/profile.png"),),
                title: Text('Profile'),
              ),

            ],
            currentIndex: ScreenLeaderboard.currentindex,
            selectedItemColor: pink,
            /* currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,*/
            onTap: (index) {
              //Handle button tap
              setState(() {
                ScreenLeaderboard.currentindex = index;
              });
            }
        ),
        body: tabs[ScreenLeaderboard.currentindex]
    );
  }
}
