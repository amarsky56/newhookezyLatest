//
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
//
//
// class AwesomeInit{
//
//   static void initAwesome(){
//     AwesomeNotifications().initialize(
//       // set the icon to null if you want to use the default app icon
//         null,
//         [
//           NotificationChannel(
//               channelKey: 'basic_channel',
//               channelName: 'Basic notifications',
//               channelDescription: 'Notification channel for basic tests',
//               defaultColor: Color(0xFF9D50DD),
//               ledColor: Colors.white
//           )
//         ]
//     );
//   }
//
//   static void showNotification(){
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         // Insert here your friendly dialog box before call the request method
//         // This is very important to not harm the user experience
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//   }
//
//   static void initAwesomeMain(){
//     initAwesome();
//     showNotification();
//   }
//
// }