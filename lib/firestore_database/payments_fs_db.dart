import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/payment.dart';
import 'package:golak/models/payout.dart';
import 'package:golak/models/user.dart';
import 'package:golak/store/notifiers/notificationsNotifier.dart';


class PaymentFirestoreDatabase {
  static final String PAYMENT = "Payments";
  static final String ROUND = "Rounds";
  static Future<bool> createPayment({String userId,String roundId,Circle circle,User user, User recipient})  {
    var payment = {
      'round':roundId,
      'from_user':userId,
      'created_at':DateTime.now(),
      'updated_at':DateTime.now(),
    };
    return  Firestore.instance.collection(PAYMENT)
        .add(payment).then((DocumentReference eventRef) async {
      return true;

    });
  }
  static Future<DocumentSnapshot> getPayment({String roundID}) async {
    return Firestore.instance.collection(PAYMENT).where('round', isEqualTo: roundID)
        .snapshots().first.then((data) {
        if(data.documents.length>0)
          return data.documents[0];
        else return null;
    });

  }
  static Future<Payment> getPaymentSum({String roundID}) async {
    return Firestore.instance.collection(PAYMENT).where('round', isEqualTo: roundID)
        .snapshots().first.then((data) {
      Payment payment = Payment.fromJson(data.documents[0].data);
      payment.id = data.documents[0].documentID;
      return payment;
    });

  }

  static Stream<List<dynamic>> getPayments({String roundID}){

    return Firestore.instance
        .collection(PAYMENT)
        .where("round",isEqualTo:roundID)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc)  {
        var payment = doc.data;
        payment['id'] = doc.documentID ;
        return payment;
      }).toList();
    });
  }
  static Stream<List<dynamic>> getUserPayments({String userID}){

    return Firestore.instance
        .collection(PAYMENT)
        .where("from_user",isEqualTo:userID)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc)  {
        var payment = doc.data;
        payment['id'] = doc.documentID ;
        return payment;
      }).toList();
    });
  }
  static Future<bool> deletePayment({String paymentId})async{

    try{

      Firestore.instance.document("${PAYMENT}/${paymentId}").get().
      then((doc) {
        doc.reference.delete();
      });

      return true;

    }catch(e){

      print("error removing deleted payment ${e}");
      return false;
    }
  }

  static Stream<List<Future<Payment>>> getUpcomingPayments({String circleId,String userId}){

    return Firestore.instance
        .collection(ROUND)
        .where("recipientId",isEqualTo: userId)
        .orderBy("end_date",descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc)  async {
        if(DateTime.now().isAfter(DateTime.parse(doc.data['end_date'].toString().split(' ').first))){
          return null;
        }
        Round round = Round.fromJson(doc.data);
        round.id = doc.documentID;
        Circle circle = await Firestore.instance.document("Circles/"+round.circleId).get().then((c){
          return Circle.fromJson(c.data);
        });
        Payment payment = new Payment(circleName:circle.name,amount:circle.minContrib,upcomingDate:round.startDate);
        return payment;
      }).toList();
    });
  }
  static Stream<List<Future<Payout>>> getUpcomingPayouts({String circleId,String userId}){

    return Firestore.instance
        .collection(ROUND)
        .where("recipientId",isEqualTo: userId)
        .orderBy("end_date",descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc)  async {
        //print(doc.data);

          if(DateTime.now().isAfter(DateTime.parse(doc.data['end_date'].toString().split(' ').first))){
            return null;
          }

        Round round = Round.fromJson(doc.data);
        round.id = doc.documentID;
        Circle circle = await Firestore.instance.document("Circles/"+round.circleId).get().then((c){
          return Circle.fromJson(c.data);
        });
        Payout payout = new Payout(circleName:circle.name,amount:circle.minContrib*circle.numUsers,upcomingDate:round.startDate);
        print(circle);
        return payout;
      }).toList();
    });
  }

}