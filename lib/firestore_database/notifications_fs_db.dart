
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golak/firestore_database/payments_fs_db.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/notification.dart';


class NotificationFirestoreDatabase {
  static final String NOTIFICATIONS = "Notifications";

  static Future<bool> createNotification(Notification notif)  {
    return  Firestore.instance.collection(NOTIFICATIONS)
        .add(notif.toJson()).then((DocumentReference eventRef) async {
      return true;

    });
  }
  static Future<Notification> getNotif({String concernUserId}) async {
    return Firestore.instance.collection(NOTIFICATIONS)
        .where('concern_user', isEqualTo: concernUserId)
        .snapshots().first.then((data) async {
      Notification notif = Notification.fromJson(data.documents[0].data);
      return notif;
    });
  }
  static Future<bool> markAsRead({String notificationId}) async {
    return Firestore.instance.collection(NOTIFICATIONS)
        .document(notificationId).updateData({"seen":true}).then((status){
          return true;
    }).catchError((error){
      return false;
    });
  }
  static Stream<List<Notification>> getNotifications(String concernUserId){

    return Firestore.instance
        .collection(NOTIFICATIONS)
        .where("concern_user",isEqualTo: concernUserId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        Notification notif = Notification.fromJson(doc.data);
        notif.id = doc.documentID;
        return notif;
      }).toList();
    });
  }
  static Stream<List<DocumentSnapshot>> getCountUnreadNotifications(String concernUserId){

    return Firestore.instance
        .collection(NOTIFICATIONS)
        .where("concern_user",isEqualTo: concernUserId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        if(doc.data['seen']==false){
          return doc;
        }
        return null;

      }).toList();
     // return snapshot.documents.length;
    });
  }

}