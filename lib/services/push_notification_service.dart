import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cubit_boiler_plate/routing/app_routing.dart';
import 'package:cubit_boiler_plate/services/webrtc_signaling.dart';
import 'package:cubit_boiler_plate/utils/colored_logs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'navigator_service.dart';

class PushNotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static bool isOpened = false;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();


  Future<String?> initNotification(BuildContext context) async {
    String? token;
    if (Platform.isIOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }
    await _firebaseMessaging.getToken().then((fcmToken) async {
      token = fcmToken;

      ColoredLogs.info('------ FCM Token: $fcmToken ------');
      await saveToken(fcmToken ?? "", context);
    });

    initPushNotifications(context);

    return token;
  }

  Future initPushNotifications(BuildContext context) async {
    _localNotifications.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings('@drawable/ic_notification'),
          iOS: DarwinInitializationSettings()),
      onDidReceiveNotificationResponse: (NotificationResponse payload) async {
        if (payload.payload != null) {
          ColoredLogs.info('------ onSelectNotification ------ $payload');
          final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
          checkForNavigation(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      ColoredLogs.info('------ onMessageOpenedApp ------');

      checkForNavigation(message);
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      ColoredLogs.info('------ onBackgroundMessage ------');

      checkForNavigation(message);
    });

    FirebaseMessaging.onMessage.listen((message) {
      ColoredLogs.info('------ onMessage ------');

      final notification = message.notification;
      if (notification == null) return;


      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  importance: Importance.max,
                  playSound: true,
                  icon: '@drawable/ic_notification'),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              )),
          payload: jsonEncode(message.toMap()));
    });
  }


  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> getInitialMessage() async {
    await _firebaseMessaging.getInitialMessage().then((message) {
      ColoredLogs.info('------ getInitialMessage ------ ${message?.data}');
      if (message != null) {
        checkForNavigation(message);
      }
    });
  }

  saveToken(String token, BuildContext context) async {
    /// Update FCM token in user document
    // final authCubit = context.read<AuthCubit>();
    // authCubit.updateUserFCMToken(fcmToken: token);
  }

  sendPushMessage({
    required String body,
    required String title,
    required String token,
    String? args,
  }) async {
    String url = ""; // Replace with your notification sending URL

    try {
      Map<String, String> data = {
        "title": title,
        "body": body,
        "token": token,
        "tag": "videoCall",
        "args": "{}",
      };

      if (args != null) {
        data['args'] = args;
      }

      ColoredLogs.info('------ Sending notification ------');
      ColoredLogs.info(data.toString());

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        ColoredLogs.info('------ ${response.body} ------');

        throw "Error while sending notification. Please try again later!";
      } else {
        ColoredLogs.success('Notification sent successfully!');
      }
    } catch (e) {
      ColoredLogs.error('------ Error sending notification : $e------');

      throw Exception("Error sending notification. Please try again later!");
    }
  }
}

checkForNavigation(RemoteMessage message) async {
  try {
    String? screenToNavigate = message.data['tag'];
    Map<String, dynamic>? args = {};
    if (message.data['args'] != null && message.data['args'] != "{}") {
      args = jsonDecode(message.data['args']);
    }

    ColoredLogs.info('------SCREEN :  $screenToNavigate ------');
    ColoredLogs.info('------ ARGS : $args ------');

    if (screenToNavigate == "null" ||
        screenToNavigate == null ) {
      return;
    }

    // if (screenToNavigate == Utils.getCurrentRoute()) {
    //   return;
    // }

    /// Navigation logic
    if (args != null) {
      final roomId = args['roomId'];

      final roomExists = await Signaling().checkIfRoomExists(roomId);

      if(!roomExists) {
        /// Room does not exist logic

        return;
      }

      await Signaling().checkIfCallAlreadyAnswered(roomId).then((value) {
        if (value) {
          /// Call already answered logic
        } else {
          /// Navigate to video call screen
          NavigatorService.navigatorKey.currentState!.pushNamed(
            AppRouting.videoCallPath,
            arguments: roomId,
          );
        }
      });

      return;
    }
  } catch (e) {
    ColoredLogs.error('------ Navigation Error ------');
    ColoredLogs.error('------ $e ------');
  }
}
