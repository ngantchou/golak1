import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golak/firestore_database/payments_fs_db.dart';
import 'package:golak/firestore_database/user_fs_db.dart';
import 'package:golak/models/circle.dart';


class RoundFirestoreDatabase {
  static final String ROUND = "Rounds";

  static Future<bool> createRound(Round round)  {
    return  Firestore.instance.collection(ROUND)
        .add(round.toJson()).then((DocumentReference eventRef) async {
      return true;

    });
  }

  static Future<Round> getRound({String circleId}) async {
   return Firestore.instance.collection(ROUND)
        .where('circleId', isEqualTo: circleId)
        //.where('start_date', isGreaterThan: DateTime.now())
        .orderBy('start_date',descending: false)

        .snapshots().first.then((data) async {
          if(data.documents.length<=0)
            return null;

          Round round ;
          for(int i=0;i< data.documents.length;i++){
           if(DateTime.now().isAfter(DateTime.parse(data.documents[i].data['start_date'].toString().split(' ').first)) &&
               DateTime.now().isBefore(DateTime.parse(data.documents[i].data['end_date'].toString().split(' ').first))){
              round = Round.fromJson(data.documents[i].data);
              round.id = data.documents[i].documentID;
              round.paymentsDoneDetails = await PaymentFirestoreDatabase.getPayments(roundID: round.id).first;
              round.paymentsDoneSum = double.parse(round.paymentsDoneDetails.length.toString());
              print("current rount is ${round.id}");
              return round;
           }
         }

         // print("current rount is ${DateTime.now().isBefore(DateTime.parse(data.documents[2].data['end_date'].toString().split(' ').first))}");
      return round;
   }
    );

  }

  static Future<bool> isReceivedPayout({String circleId,String recipiendId}) async {
    return Firestore.instance.collection(ROUND)
        .where('circleId', isEqualTo: circleId)
        .orderBy('start_date',descending: false)
        .snapshots().first.then((data) async {
      if(data.documents.length<=0)
        return false;

      for(int i=0;i< data.documents.length;i++){
        if(DateTime.now().isBefore(DateTime.parse(data.documents[i].data['start_date'].toString().split(' ').first))
          && data.documents[i].data['recipientId']==recipiendId){
          return true;
        }
      }
       return false;
    });

  }

  static Stream<List<String>> getRoundForCircle({String circleId}){

    return Firestore.instance
        .collection(ROUND)
        .where("circleId",isEqualTo:circleId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc)  {
        return doc.documentID;
      }).toList();
    });
  }
  static Stream<List<Future<Round>>> getUserIDRoundForCircle({String circleId}){

    return Firestore.instance
        .collection(ROUND)
        .where("circleId",isEqualTo:circleId)
        .orderBy('start_date',descending: false)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc)  async {
        Round round = Round.fromJson(doc.data);
        round.id = doc.documentID;
        round.recipiend =
            await UserFirestoreDatabase.getUserAccountDatasWithProfiles(
            circleId: null,userId: round.recipientId);
        return round;
      }).toList();
    });
  }
  static Future<void> deleteRound(String userId){
    return Firestore.instance
        .collection(ROUND)
        .where("recipientId",isEqualTo: userId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        print(doc.documentID);
        Firestore.instance
            .document("${ROUND}/${doc.documentID}").delete();
        return doc.documentID;
      });
    });
  }

}