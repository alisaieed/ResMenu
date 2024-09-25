import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

request_Permission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

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

sendMessageTopic(title, message, topic) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAdLPXLHM:APA91bFyWt354Yr1Ndczt0si8Xee1MakSlQj6J8qJL6yQ-HEEyVpvk6k2Oio8VVV9zD3Jyg4VKdGrjuxRLjQy5xPEp2KkS95hAyAjomfE3-4NfrOYwzYAFyT1s1CeurdgLl0fUYBRiBx',
  };

  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "/topics/$topic",
    "notification": {"title": title, "body": message},
    // "data": {"type" : "alert", "m" : "wm"}
  };

  var req = http.Request('Post', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
