
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:golak/firestore_database/payments_fs_db.dart';
import 'package:golak/firestore_database/round_fs_db.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/payment.dart';
import 'package:golak/models/recentActivity.dart';
import 'package:golak/models/user.dart';



class UserFirestoreDatabase {



  static  Future<User> login({String email, String password}) async {

    FirebaseUser fbUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    if(!fbUser.isEmailVerified)
      fbUser.sendEmailVerification();
    User user = await getUserAccountDatasWithProfiles(circleId: null,userId: fbUser.uid);
    return user;
  }

  static Future<User> getUserAccountDatasWithProfiles({String userId,String circleId })async{

    try{

      User user = User.fromDocument(await Firestore.instance.document("Users/$userId").get());
      if(circleId!=null) {
        user.isPay = await RoundFirestoreDatabase.isReceivedPayout(
            recipiendId: userId, circleId: circleId);
      }
      return user;

    }catch(PlatformException){

      print("error getting account with profile infos: $PlatformException");
      return null;
    }
  }

  static Future<String> signUp({String email, String password}) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      user.sendEmailVerification();
      return user.uid;
    }catch(e){

    // print(e.message);
     User u = await getUserByEmail(email);
     print("user exists is ${u}");
     return u.id;
    /* if (Platform.isAndroid) {
       if(e.code=="The email address is already in use by another account"){
         User u = await getUserByEmail(email);
         return u.id;
       }
     } else if (Platform.isIOS) {
       if(e.code=="The email address is already in use by another account"){
         User u = await getUserByEmail(email);
         return u.id;
       }
     }*/
    }
  }

  static Future<String> Register({String username,String email, String password,String phone,String country}) async {

    String userID = await signUp(email: email, password: password);
    User user = new User(
      id: userID,
      username: username,
      email: email,
      phone: phone,
      image: "",
      playerId: "",
      isPay: false,
      country: country,
    );
    bool added = await addUser(user);

    return userID;
  }

  static Future<bool> addUser(User user) async {
    return checkUserExistence(user.id).then((exists) {
      if (!exists) {

        Firestore.instance
            .document("Users/${user.id}")
            .setData(user.toJson(), merge: true);
        print("user ${user.email} added");

      } else {
        print("user ${user.email} exists");
      }

      return !exists;
    });
  }

  static Stream<List<User>> getUserStreamList(){

    return Firestore.instance
        .collection("Users")
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        User user = User.fromDocument(doc);
        //if(!admins.contains(user.email))return null;
        return user;
      }).toList();
    });
  }
  static Stream<List<User>> getUserCircle(List<dynamic> c){

    return Firestore.instance
        .collection("Users")
        .where("id",whereIn: c)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        User user = User.fromDocument(doc);
        return user;
      }).toList();
    });
  }
  static Future<User> getUserOfCircle(String circleId,String  userId){

    return Firestore.instance
        .document("Users/$userId")
        .get()
        .then((DocumentSnapshot doc) async {
        User user = User.fromDocument(doc);
        user.isPay = await RoundFirestoreDatabase.isReceivedPayout(circleId: circleId,recipiendId: userId);
        return user;
      });
  }
  static Future<User> getUserByEmail(String email){

    return Firestore.instance
        .collection("Users")
        .where("email",isEqualTo: email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        User user = User.fromDocument(doc);
        return user;
      }).first;
    });
  }
  static Future<String> deleteUser(String userId){
    return Firestore.instance
        .document("Users/${userId}")
        .delete();

  }
  static Future<bool> checkUserExistence(String userID) async {
    try {
      return await Firestore.instance.document("Users/${userID}").get().then((doc) {
        if (doc.exists)
          return true;
        else
          return false;
      });
    } catch (e) {
      return false;
    }
  }

  static Stream<List<Future<RecentActivity>>> getRecentPayout({String userId})  {

     return Firestore.instance
        .collection("Rounds")
        .where("recipientId",isEqualTo: userId)
        .orderBy("end_date",descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc)  async {

        Round round = Round.fromJson(doc.data);
        round.id = doc.documentID;
        Circle circle = await Firestore.instance.document("Circles/"+round.circleId).get().then((c){
          return Circle.fromJson(c.data);
        });
        DocumentSnapshot payment = await PaymentFirestoreDatabase.getPayment(roundID: doc.documentID);

        if(payment==null){
          return null ;
        }

       String activity = 'you received a payment from ${circle.name}';
        RecentActivity recentActivity = RecentActivity.fromJson({'amount': circle.minContrib,'paymentDate': payment["created_at"].toDate().toString(),'title':activity});
        return recentActivity;
      }).toList();
    });

  }
  static Stream<List<Future<RecentActivity>>> getRecentPayment({String userId})  {

     return Firestore.instance
        .collection("Payments")
        .where("from_user",isEqualTo: userId)
        .orderBy("created_at",descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc)  async {
        print(doc.data);
        Round round = await Firestore.instance.document("Rounds/"+doc.data['round']).get().then((c){
          Round round = Round.fromJson(c.data);
          round.id = c.documentID;
          return round;
        });
        Circle circle = await Firestore.instance.document("Circles/"+round.circleId).get().then((c){
          return Circle.fromJson(c.data);
        });

       String activity = 'you made a payment to ${circle.name}';

        RecentActivity recentActivity = RecentActivity.fromJson({'amount': circle.minContrib.toString(),'paymentDate': doc.data["created_at"].toDate().toString(),'title':activity});
        return recentActivity;
      }).toList();
    });

  }

  static Future<bool> updateOnesignalId({String userId,String playerId}) async {
    return Firestore.instance.collection("Users")
        .document(userId).updateData({"playerId":playerId}).then((status){
      return true;
    }).catchError((error){
      return false;
    });
  }
  static Future<bool> updateProfilePicture({String userId,String picture}) async {
    return Firestore.instance.collection("Users")
        .document(userId).updateData({"image":picture}).then((status){
      return true;
    }).catchError((error){
      return false;
    });
  }
  @override
  static Future<bool> resetPasswordResetEmail(String email) async {

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return true;
  }

}