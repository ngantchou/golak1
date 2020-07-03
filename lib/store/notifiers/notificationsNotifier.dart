import 'dart:convert';
import 'package:golak/firestore_database/notifications_fs_db.dart';
import 'package:golak/firestore_database/user_fs_db.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/user.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
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
  void onChange() {
    notifyListeners();
  }
  bool _opening = false;
  bool get opening => _opening;
  set opening(bool $opening) {
    _opening = $opening;
    onChange();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool $loading) {
    _loading = $loading;
    onChange();
  }
  int _unreadNotifCount = 0;

  int get unreadNotifCount => _unreadNotifCount;

  set unreadNotifCount(int $number){
    _unreadNotifCount = $number;
  }
  List<Notification> _notifications;
  List<Notification> get notifications => _notifications;
  set notifications(List<Notification> $notifications) {
    _notifications = $notifications;
    onChange();

    /*if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
          'notifications',
          json.encode(_notifications.map((Notification notification) {
            return notification.toJson();
          }).toList()),
        );
      });*/
  }

  init({rememberMe, accessToken, userId}) async {
    rememberMe = rememberMe;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedNotifications = prefs.getString('notifications');
   /* if (encodedNotifications != null) {
      final List<dynamic> jsonNotifications = json.decode(encodedNotifications);
      notifications = jsonNotifications.map((jsonNotification) {
        return Notification.fromJson(jsonNotification);
      }).toList();
    }*/
    await getNotifications(
      accessToken: accessToken,
      userId: userId,
    );
  }

  Future<List<Notification>> getNotifications(
      {@required accessToken, @required userId}) async {
    loading = true;
    List<Notification> $notifications;
    try {
        $notifications  = await NotificationFirestoreDatabase.getNotifications(
         userId,
      ).first;
    } catch (e) {}
    if ($notifications != null) {

      if ($notifications.length > 0) notifications = $notifications;
      loading = false;
      return $notifications;
    } else {
      loading = false;
      return null;
    }
  }
  Future<bool> markAsRead({ @required notificationId}) async {
    loading = true;
    bool $notifications;
    try {
      $notifications  = await NotificationFirestoreDatabase.markAsRead(
        notificationId: notificationId,
      );

    } catch (e) {}
    loading = false;
    return $notifications;
  }
  Future<int> getCountUnreadNotification({ @required notificationId}) async {
     int $notifications;


    return $notifications;
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

  initOneSignal(String userId) async {
    OneSignal.shared.init("82d52095-a14d-4827-8d91-19aba6e9c37a");
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared
        .setNotificationReceivedHandler(_handleNotificationReceived);
    OneSignal.shared.setNotificationOpenedHandler(_handleNotificationOpened);

    final status = await OneSignal.shared.getPermissionSubscriptionState();
    playerId = status.subscriptionStatus.userId;

    final AuthenticationNotifier authenticationNotifier = AuthenticationNotifier();
    print("want to set playerdID to : $userId");
    authenticationNotifier.updateOnesignalPlayerId(
      userId: userId,
      playerId: playerId,
    );
  }

  static notifyPaymentDone({String circleName,String facilitatorName,String fromUserId}){
    var notifContent = {
      "en": "Your Facilitator, ${
          facilitatorName
      } has just marked you as Paid for the ${circleName} Circle"
    };
    _handleSendNotification("Payment done",notifContent["en"],fromUserId);
  }
  
  static notifyPayoutDone({String circleName, String toUserId}){
    var notifContent = {
      "en": "Congratulations! you have received a payout for the ${
          circleName
      } circle."
    };
    _handleSendNotification("Payout done",notifContent["en"],toUserId);
  }
  
  static notifyPayoutMarked({String fromUsername,String circleName,String facilitatorId}){
    var notifContent = {
      "en": "You have just marked ${fromUsername} as Paid for the ${
          circleName
      } circle"
    };
    _handleSendNotification("Paymentt Marked",notifContent["en"],facilitatorId);
  }
  
  static notifyNextRoundUser({String circleName,DateTime nextRoundDatetime,String recipientUsername,String nextUserRoundId}){
    var notifContent = {
      "en": "This week, ${recipientUsername} received a payout for the ${
          circleName
      } circle. You are scheduled to receive a payout on ${nextRoundDatetime.toString()}"
    };
    _handleSendNotification("Next round",notifContent["en"],nextUserRoundId);
  }
  
  static void _handleSendNotification(String title, String message,String concern_user) async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
    User user = await  UserFirestoreDatabase.getUserAccountDatasWithProfiles(userId: concern_user,circleId: null);
     playerId = user.playerId;
    var imgUrlString =
        "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

    var notification = OSCreateNotification(
        playerIds: [playerId],
        content: message,
        heading: title,
        iosAttachments: {"id1": imgUrlString},
        bigPicture: imgUrlString,
        buttons: [
          OSActionButton(text: "ok", id: "id1"),
        ]);

    var response = await OneSignal.shared.postNotification(notification);
     

      Notification notif = new Notification(id:null,updated_at: DateTime.now(),created_at: DateTime.now(),concern_user: concern_user,message: message,seen: false);
      NotificationFirestoreDatabase.createNotification(notif);


    print("Sent notification with response: $response");
  }
  void _handleNotificationReceived(OSNotification notification) {
    notifications.insert(
      0,
      Notification(
        id: notification.payload.notificationId,
        message: notification.payload.body,
        created_at: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void _handleNotificationOpened(OSNotificationOpenedResult result) {
    opening = true;
    notifyListeners();
  }
}
