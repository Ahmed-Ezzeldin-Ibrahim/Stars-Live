
import '../main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';

class NoificationRepo extends StatefulWidget {
  Widget child;
  NoificationRepo({this.child});
  @override
  _NoificationRepoState createState() => _NoificationRepoState();
}

class _NoificationRepoState extends State<NoificationRepo> {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void getCheckNotificationPermStatus() {
    NotificationPermissions.getNotificationPermissionStatus().then((status) {
      switch (status) {
        case PermissionStatus.denied:
        case PermissionStatus.unknown:
          requestNotificationPermission();
          break;
        case PermissionStatus.provisional:
        case PermissionStatus.granted:
          requestNotificationPermission();
          break;
        default:break;
      }
    });
  }

  void requestNotificationPermission(){
    NotificationPermissions.requestNotificationPermissions(
      iosSettings: const NotificationSettingsIos(
          sound: true, badge: true, alert: true),
      openSettings: true,
    );
  }

  void configurationNotifications(){
    // _firebaseMessaging.requestPermission(sound: true,badge: true,alert: true);
    // FirebaseMessaging.onMessage.listen((message) {
    //   print('on message ${message} you are in onMessage');
    //   Navigator.of(navigatorKey.currentContext).pushNamed('/pagesWidget',arguments: 0);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('on launch $message');
    //   print('on>>>>>>>>>>>>> resume $message');
    //   Navigator.of(navigatorKey.currentContext).pushNamed('/pagesWidget',arguments: 0);
    // });
  
  }
  @override
  void initState() {
    getCheckNotificationPermStatus();
    Future.delayed(Duration(seconds: 1), () {configurationNotifications();}
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}