import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {

    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
      ),
    );


  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>

  _notifications.show(id, title, body, await _notificationDetails(),
  payload: payload
  );

}

// Future<void> createEventNotification() async {
//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: createUniqueId(), 
//       channelKey: 'basic_channel',
//       title: '${Emojis.activites_japanese_dolls} Buy',
//       body: 'Event 123',
//       notificationLayout: NotificationLayout.BigText,
//   ),);
// }

