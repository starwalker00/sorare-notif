import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  print('@@@@@ Background message received!');
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;
  
  // Stream for link with main view
  final listCtlr = StreamController<List<String>>.broadcast();

  setNotifications() {
    // When notification received when app is backgrounded
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    // When notification received when app is backgrounded is clicked
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('@@@@@ Background message clicked!');
      listCtlr.sink.add([message.notification!.title!, message.notification!.body!]);
    });
    // When notification received when app is foregrounded
    FirebaseMessaging.onMessage.listen(
      (message) async {
        print('@@@@@ Foreground message received!');
        print("onMessage: $message");
        // Update the main view
        listCtlr.sink.add([message.notification!.title!, message.notification!.body!]);
      },
    );
    // With this token you can test it easily on your phone
    final token =
        _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  dispose() {
    listCtlr.close();
  }
}