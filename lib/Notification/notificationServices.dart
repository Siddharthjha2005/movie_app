import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true, // device pe show hoga notification
      announcement: true, // sivi can read notification
      badge: true, // top of the icon it show no. of message
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
      // providesAppNotificationSettings: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted permission");
    } // android
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");
    } // ios
    else {
      AppSettings.openAppSettings();
      print("User denied permission");
    }
  }

  Future<String> getToken() async{
    String? token = await messaging.getToken();
    return token!;
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message){
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      if(Platform.isAndroid){
        initLocalNotifications(context,message);
      }
      showNotification(message);
    });
  }

  // it store logo and help in navigation
  Future<void> initLocalNotifications(BuildContext context,RemoteMessage
  message) async{
    var androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // navigation logic
        // handleMessage(context, message);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notifications',
        importance: Importance.max
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'your channel Description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker'
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails
    );

    Future.delayed(
        Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails
      );
    });
  }

  // void handleMessage(BuildContext context,RemoteMessage message) {
  //   if(message.data['type']=='msg'){
  //     Navigator.push(context, MaterialPageRoute(builder: (context) =>
  //         MessageScreen(id: message.data['id'],),));
  //   }
  // }
  //
  // // terminated / background
  // Future<void> setupInteractMessage(BuildContext context) async{
  //
  //   // when app is terminated
  //   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  //
  //   if(initialMessage != null){
  //     handleMessage(context, initialMessage);
  //   }
  //
  //   // when app is inbackground
  //   FirebaseMessaging.onMessageOpenedApp.listen((event){
  //     handleMessage(context, event);
  //   });
  // }

}