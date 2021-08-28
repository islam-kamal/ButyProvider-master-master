// import 'package:flutter/material.dart';
// import 'package:rxdart/subjects.dart';
import 'dart:async';

import 'package:BeauT_Stylist/UI/bottom_nav_bar/hom_page.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/notifications.dart';
import 'package:BeauT_Stylist/models/home_page_response.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NetworkUtil.dart';

class AppPushNotifications {
  FirebaseMessaging _firebaseMessaging;
  GlobalKey<NavigatorState> navigatorKey;

//  MainModel model = MainModel();

  static StreamController<Map<String, dynamic>> _onMessageStreamController =
  StreamController.broadcast();
  static StreamController<Map<String, dynamic>> _streamController =
  StreamController.broadcast();

  static final Stream<Map<String, dynamic>> onFcmMessage =
      _streamController.stream;

  void notificationSetup(GlobalKey<NavigatorState> navigatorKey) {
    _firebaseMessaging = FirebaseMessaging();
    this.navigatorKey = navigatorKey;
    print("===================================");
    requestPermissions();
    getFcmToken();
    notificationListeners();
  }

  StreamController<Map<String, dynamic>> get notificationSubject {
    return _onMessageStreamController;
  }

  void requestPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
  }

  Future<String> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((String token) async{
      assert(token != null);
      prefs.setString('msgToken', token);
      print("token : ${token}");
    });
    print('firebase token => ${await _firebaseMessaging.getToken()}');

    print("_____________" + await _firebaseMessaging.getToken());
    return await _firebaseMessaging.getToken();
  }

  void notificationListeners() {
    _firebaseMessaging.configure(
        onMessage: _onNotificationMessage,
        onResume: _onNotificationResume,
        onLaunch: _onNotificationLaunch);
  }

  Future<dynamic> _onNotificationMessage(Map<String, dynamic> message) async {
    print("------- ON MESSAGE -------5555555----- $message");
    print("message : $message");
    print("----- order ------ ${message["data"]}");
     notificationAction(
       messagee: message["notification"]["body"],
       order: message["data"]
     );
// _notificationSubject.add(message);
    _onMessageStreamController.add(message);
  }

  Future<dynamic> _onNotificationResume(Map<String, dynamic> message) async {
//    navigatorKey.currentState.push(PageRouteBuilder(pageBuilder: (_, __,___) {
//      print(message["data"]["status"]);
////      return  Notifications();
//    }));
    print("------- ON RESUME ------66666666------ $message");
    notificationAction(
        messagee: message["notification"]["body"],
        order: message["data"]
    );
// _notificationSubject.add(message);
//     notificationAction(message["data"]["title"]);
    print("message : $message");
    _streamController.add(message);
  }

  Future<dynamic> _onNotificationLaunch(Map<String, dynamic> message) async {
    print("------- ON LAUNCH -----7777777777777------- $message");
    notificationAction(
        messagee: message["notification"]["body"],
        order: message["data"]
    );
// _notificationSubject.add(message);
    print("message : $message");

    _streamController.add(message);
    // notificationAction(message["notification"]["title"]);

//    navigatorKey.currentState.push(PageRouteBuilder(pageBuilder: (_, __,___) {
//    return  Notifications();
//    }));
  }

  void killNotification() {
    _onMessageStreamController.close();
    _streamController.close();
  }

 void notificationAction({String messagee , Orders order}) async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   print(messagee);
   print("!!!!!!!!!!order : ${order}");
       messagee == "لديك حجز جديد! فضاًل اختاري قبول أو رفض الحجز"
           ? navigatorKey.currentState.push(PageRouteBuilder(pageBuilder: (_, __, ___) {
              return HomePage(
                new_order_notification: true,
                order_id: order.id,
              );
            }))
           : navigatorKey.currentState
               .push(PageRouteBuilder(pageBuilder: (_, __, ___) {
              return Notifications();
             }));


 }
}
