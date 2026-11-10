import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class FirebaseNotifications {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> initializeFirebase() async {
    Platform.isAndroid ? 
     await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCPs1phi6VZFbPa65khiOfFnoORP-ygVcU',
        appId: '1:135547164721:android:2b6750d7f8ef7d4e065d10',
        messagingSenderId: '135547164721',
        projectId: 'mika-care',
        storageBucket: 'mika-care.appspot.com',
      ),
     ) 
    : 
    await Firebase.initializeApp();
    
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await requestPermission();
    await getToken();
    handleMessage();
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<void> getToken() async {
    String? token = await messaging.getToken();
    print("FirebaseMessaging token: $token");
  }

  static void handleMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      RemoteNotification? notification = message.notification;
      if (notification != null) {
        flutterToast(notification.title ?? 'No Title', notification.body ?? 'No Body');
      }
    });
  }

  static void flutterToast(String title, String body) {
    Fluttertoast.showToast(
      msg: "$title\n$body",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[900],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");

    // Here you can handle the background message
    // Example: Update local database, show a notification, etc.

    // Placeholder for showing local notification
    showLocalNotification(message);
  }

  // static Future<void> backgroundMessageHandler(RemoteMessage message) async {
  //   print("Handling a background message: ${message.messageId}");
  //   RemoteNotification? notification = message.notification;
  //   if (notification != null) {
  //     showLocalNotification(notification);
  //   }
  // }

  static void showLocalNotification(RemoteMessage message) {
    // Use a local notification package to show a notification
    // This is a placeholder function
    print('Would show a notification: Title: ${message.notification?.title}, Body: ${message.notification?.body}');
  }

  // static void showLocalNotification(RemoteNotification notification) {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'your_channel_id', // Replace with your own channel id
  //     'your_channel_name', // Replace with your channel name
  //     channelDescription: 'your_channel_description', // Replace with your channel description
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   flutterLocalNotificationsPlugin.show(
  //     0, // Replace with a unique id for each notification
  //     notification.title,
  //     notification.body,
  //     platformChannelSpecifics,
  //     payload: 'item x', // Optional payload
  //   );
  // }
}
