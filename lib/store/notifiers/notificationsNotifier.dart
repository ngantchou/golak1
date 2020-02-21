import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:golak/models/notification.dart';
import 'package:golak/network/notifications.dart' as notificationsNetwork;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsNotifier with ChangeNotifier {
  String _playerId;
  String get playerId => _playerId;
  set playerId(String $playerId) {
    _playerId = $playerId;
    notifyListeners();
  }

  bool _opening = false;
  bool get opening => _opening;
  set opening(bool $opening) {
    _opening = $opening;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool $loading) {
    _loading = $loading;
    notifyListeners();
  }

  List<Notification> _notifications;
  List<Notification> get notifications => _notifications;
  set notifications(List<Notification> $notifications) {
    _notifications = $notifications;
    notifyListeners();

    if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
          'notifications',
          json.encode(_notifications.map((Notification notification) {
            return notification.toJson();
          }).toList()),
        );
      });
  }

  init({rememberMe, accessToken, userId}) async {
    rememberMe = rememberMe;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedNotifications = prefs.getString('notifications');
    if (encodedNotifications != null) {
      final List<dynamic> jsonNotifications = json.decode(encodedNotifications);
      notifications = jsonNotifications.map((jsonNotification) {
        return Notification.fromJson(jsonNotification);
      }).toList();
    }
    await getNotifications(
      accessToken: accessToken,
      userId: userId,
    );
  }

  Future<String> getNotifications(
      {@required accessToken, @required userId}) async {
    loading = true;
    var $response;
    try {
      $response = await notificationsNetwork.getNotifications(
        accessToken: accessToken,
        userId: userId,
      );
    } catch (e) {}
    if ($response != null) {
      List<dynamic> jsonNotifications = $response['notifications'];
      final List<Notification> $notifications =
          jsonNotifications.map((notification) {
        return Notification(
            id: notification['_id'],
            message: notification['message']['en'],
            createdAt: DateTime.parse(notification['createdAt']));
      }).toList();
      if ($notifications.length > 0) notifications = $notifications;
      loading = false;
      return accessToken;
    } else {
      loading = false;
      return null;
    }
  }

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;
  set rememberMe(bool $rememberMe) {
    _rememberMe = $rememberMe;
    notifyListeners();
  }

  clean() {
    notifications = [];
    notifyListeners();
  }

  initOneSignal() async {
    OneSignal.shared.init("a8087787-ff09-405f-b034-5102dbc9031a");
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared
        .setNotificationReceivedHandler(_handleNotificationReceived);
    OneSignal.shared.setNotificationOpenedHandler(_handleNotificationOpened);

    final status = await OneSignal.shared.getPermissionSubscriptionState();
    playerId = status.subscriptionStatus.userId;
  }

  void _handleNotificationReceived(OSNotification notification) {
    notifications.insert(
      0,
      Notification(
        id: notification.payload.notificationId,
        message: notification.payload.body,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void _handleNotificationOpened(OSNotificationOpenedResult result) {
    opening = true;
    notifyListeners();
  }
}
