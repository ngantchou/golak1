import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golak/firestore_database/payments_fs_db.dart';
import 'package:golak/firestore_database/round_fs_db.dart';
import 'package:golak/firestore_database/user_fs_db.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/ledger.dart';
import 'package:golak/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CircleFirestoreDatabase {
  static final String CIRCLES = "Circles";


  static Future<Circle> createCircle({
    String accessToken,
    String name,
    double minContrib,
    String contribType,
    double totalAmount,
    List<User> involvedUsers,
    DateTime startDate,
    })  async {

    int periode = 1;
    List<String> usersID = new List<String>();
    var d1 = startDate;
    var d2 ;
    switch(contribType){
      case "daily": periode = 1;break;
      case "weekly": periode = 7;break;
      case "bi-weekly": periode = 3;break;
      case "monthly": periode = 30;break;
    }


    involvedUsers.sort((a, b) => a.order - b.order);

    for(int i = 0; i < involvedUsers.length; i++){

      print("compare = ${involvedUsers.length}");

      final $response = await UserFirestoreDatabase.Register(
        username: involvedUsers[i].username,
        email: involvedUsers[i].email,
        password: "${involvedUsers[i].username.toString()}@2020",
        phone: involvedUsers[i].phone,
        country: "",
      );

      if ($response == null) {

        return null;
      }
      usersID.add($response);

    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    var body = {
      'name': name,
      'minContrib': minContrib.toString(),
      'contribType': contribType.toString().toLowerCase(),
      'totalAmount': totalAmount.toString(),
      'numUsers': involvedUsers.length,
      'involvedUsers': usersID,
      'startDate': startDate,
      'created_at': DateTime.now(),
      "updated_at": DateTime.now(),
      "createdById": accessToken,
    };
    return  Firestore.instance.collection(CIRCLES)
            .add(body).then((DocumentReference circleRef) async {

      for(int i = 0; i < usersID.length; i++){

        d2 = d1.add(new Duration(days:periode));
        Round round =  Round(
            startDate:d1 ,
            recipientId: usersID[i],
            endDate: d2 ,
            circleId:circleRef.documentID,
            created_at: DateTime.now(),
            updated_at: DateTime.now());
        final $response = await RoundFirestoreDatabase.createRound(round);
        if ($response == null) {

          return null;
        }
        d1 = d2 ;

      }
      return await getCircles(id: circleRef.documentID);

    });
  }

  static Future<Circle> getCircles({@required id}) async {
    DocumentSnapshot doc = await Firestore.instance.document("Circles/${id}").get();

    Circle circle = Circle.fromJson(doc.data);
    circle.id = id;
    circle.currentRound = await RoundFirestoreDatabase.getRound(circleId: circle.id);
    circle.users = await UserFirestoreDatabase.getUserCircle(doc.data['involvedUsers']).first;
    print("le cercle enregistré est ${circle}");
    return circle;
  }

  static Stream<List<Future<Circle>>> getCirclesList(String createdBy){

    return Firestore.instance
        .collection(CIRCLES)
        .where("involvedUsers",arrayContains:createdBy)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) async {
        Circle circle = Circle.fromJson(doc.data);
        circle.id = doc.reference.documentID;
        circle.currentRound = await RoundFirestoreDatabase.getRound(circleId: circle.id);
        if(circle.currentRound!=null) {
          circle.currentRound.recipiend =
          await UserFirestoreDatabase.getUserAccountDatasWithProfiles(
             userId: circle.currentRound.recipientId,circleId: null);
        }
        List<dynamic> stringList = doc.data['involvedUsers'];
        List<User> list = [];
        for(var i=0;i<stringList.length;i++){
          list.add(await UserFirestoreDatabase.getUserAccountDatasWithProfiles(circleId:circle.id ,userId: stringList[i]));
          print(stringList[i]);
        }
        circle.users = list;
        return circle;
      }).toList();
    });
  }
  static Stream<List<Future<Circle>>> getCirclesManager(String createdBy){

    return Firestore.instance
        .collection(CIRCLES)
        .where("createdById",isEqualTo:createdBy)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) async {
        Circle circle = Circle.fromJson(doc.data);
        circle.id = doc.reference.documentID;
        circle.currentRound = await RoundFirestoreDatabase.getRound(circleId: circle.id);
        if(circle.currentRound!=null) {
          circle.currentRound.recipiend =
          await UserFirestoreDatabase.getUserAccountDatasWithProfiles(
              circleId: null,userId: circle.currentRound.recipientId);
        }
        List<dynamic> stringList = doc.data['involvedUsers'];
        circle.users = await UserFirestoreDatabase.getUserCircle(stringList).first;
        return circle;
      }).toList();
    });
  }
  static Future<String> addParticipant({ accessToken, User user,  circleId}) async {


    try{

      DocumentSnapshot doc = await Firestore.instance.document("Circles/${circleId}").get();

      Circle circle = Circle.fromJson(doc.data);


    final userId = await UserFirestoreDatabase.Register(
      username: user.username,
      email: user.email,
      password: "${user.username}@2020",
      phone: user.phone,
      country: "",
    );
    if (userId == null) {
      print("user cercle error bye bye :");
      return null;
    }
      circle.involvedUsers.add(userId);
      circle.totalAmount = circle.minContrib + circle.totalAmount;
      circle.numUsers = circle.numUsers+1;

    List<DateTime> list = getEndDate(circle);
    Round round =  Round(
        startDate: list[0],
        recipientId: userId,
        endDate: list[1] ,
        circleId: circleId,
        created_at: DateTime.now(),
        updated_at: DateTime.now());

    final $response = await RoundFirestoreDatabase.createRound(round);
    if (!$response) {
      print("round cercle error bye bye :");
      return null;
    }
      print($response);

      Firestore.instance.collection(CIRCLES).document(circleId).updateData({'totalAmount': circle.totalAmount}).then((result){
        print("update totalAmount done !");
      }).catchError((onError){
        print("onError");
      });
      Firestore.instance.collection(CIRCLES).document(circleId).updateData({'numUsers': circle.numUsers}).then((result){
        print("update numUsers done !");
      }).catchError((onError){
        print("onError");
      });
      Firestore.instance.collection(CIRCLES).document(circleId).updateData({'involvedUsers': circle.involvedUsers}).then((result){
        print("update involvedUsers done !");
      }).catchError((onError){
        print("onError");
      });
      return userId ;
    }catch(e){
      print('exception occured $e');
    }
  }

  static Future<String> deleteParticipant({String userId,  circleId}) async {


    try{

      Circle circle = await getCircles(id: circleId);

      /*final deletedUserId = await UserFirestoreDatabase.deleteUser(
          userId
      );

      if (userId == null) {

        return null;
      }*/



       RoundFirestoreDatabase.deleteRound(userId);

      circle.involvedUsers.remove(userId);
      circle.totalAmount = circle.totalAmount - circle.minContrib;
      circle.numUsers = circle.numUsers-1;

      Firestore.instance.collection(CIRCLES).document(circleId).updateData({'totalAmount': circle.totalAmount}).then((result){
        print("update totalAmount done !");
      }).catchError((onError){
        print("onError");
      });
      Firestore.instance.collection(CIRCLES).document(circleId).updateData({'numUsers': circle.numUsers}).then((result){
        print("update numUsers done !");
      }).catchError((onError){
        print("onError");
      });
      Firestore.instance.collection(CIRCLES).document(circleId).updateData({'involvedUsers': circle.involvedUsers}).then((result){
        print("update involvedUsers done !");
      }).catchError((onError){
        print("onError");
      });
      return userId ;
    }catch(e){
      print('$e');
    }
  }
  static List<DateTime> getEndDate(Circle circle){

    DateTime end_date = null ;
    DateTime new_end_date = null ;
    switch(circle.contribType){
      case "monthly" : end_date = DateTime(circle.startDate.year, circle.startDate.month +circle.involvedUsers.length , circle.startDate.day);new_end_date= end_date.add(new Duration(days:30));break;
      case "dayly" : end_date = DateTime(circle.startDate.year, circle.startDate.month, circle.startDate.day +circle.involvedUsers.length);new_end_date= end_date.add(new Duration(days:1));break;
      case "bi-weekly" : end_date = DateTime(circle.startDate.year, circle.startDate.month +circle.involvedUsers.length , circle.startDate.day + 3*circle.involvedUsers.length);new_end_date= end_date.add(new Duration(days:3));break;
      case "weekly" : end_date = DateTime(circle.startDate.year, circle.startDate.month +circle.involvedUsers.length , circle.startDate.day + 7*circle.involvedUsers.length);new_end_date= end_date.add(new Duration(days:7));break;
    }
    List<DateTime> list = new List<DateTime>();
    list.add(end_date);
    list.add(new_end_date);
    return list;
  }
  static Stream<List<Future<Ledger>>> getLedger({String circleId,List<String> roundIds})  {

    return Firestore.instance
        .collection("Payments")
        .where("round",whereIn: roundIds)
        //.orderBy("end_date",descending: false)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc)  async {
        print("test test :${doc.data}");
        User user = await UserFirestoreDatabase.getUserAccountDatasWithProfiles(userId: doc.data["from_user"],circleId: null);

        Circle circle = await Firestore.instance.document("Circles/"+circleId).get().then((c){
          return Circle.fromJson(c.data);
        });
        Ledger recentActivity = Ledger(creditScore:'N/A' ,drawDate:doc.data["created_at"].toDate() ,lateFees: 'N/A',outstandingAmount: 'N/A',paid: circle.minContrib,userName: user.username);
        //print(doc);
        return recentActivity;
      }).toList();
    });

  }

}