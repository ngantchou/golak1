import 'dart:convert';

import 'package:golak/firestore_database/payments_fs_db.dart';
import 'package:golak/models/payment.dart';
import 'package:golak/models/user.dart';
import 'package:golak/network/payments.dart' as paymentsNetwork;
import 'package:flutter/foundation.dart';
import 'package:golak/store/notifiers/notificationsNotifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentsNotifier with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool $loading) {
    _loading = $loading;
    onChange();
  }
  void onChange() {
    notifyListeners();
  }
  List<Payment> _payments;
  List<Payment> get payments => _payments;
  set payments(List<Payment> $payments) {
    _payments = $payments;
    onChange();

    /*if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
          'payments',
          json.encode(_payments.map((Payment payment) {
            return payment.toJson();
          }).toList()),
        );
      });*/
  }

  init({rememberMe, accessToken, userId}) async {
    rememberMe = rememberMe;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedPayments = prefs.getString('payments');
    if (encodedPayments != null) {
      final List<dynamic> jsonPayments = json.decode(encodedPayments);
      payments = jsonPayments.map((jsonPayment) {
        return Payment.fromJson(jsonPayment);
      }).toList();
    }
    await getPayments(
      accessToken: accessToken,
      userId: userId,
    );
  }

  Future<String> getPayments({@required accessToken, @required userId}) async {
    loading = true;
    List<Payment> $payments ;
    try {
      $payments = await PaymentFirestoreDatabase.getPayments(
        roundID: userId,
      ).first;
      print($payments);
    } catch (e) {}
    if ($payments != null) {
      if ($payments.length > 0) payments = $payments.reversed.toList();
      loading = false;
      return accessToken;
    } else {
      loading = false;
      return null;
    }
  }

  Future<String> createPayment({
    @required accessToken,
    @required createdBy,
    @required userPayName,
    @required userId,
    @required roundId,
    @required amount,
    @required nextUserRoundId,
    @required circleName,
    @required recipiendName,
    @required upcomingDate,
  }) async {
    loading = true;
    var $response;
    try {
      $response = await PaymentFirestoreDatabase.createPayment(
        userId: userId,
        roundId: roundId,
      );
    } catch (e) {}
    if ($response) {
      final Payment _payment = Payment(
        amount: amount,
        circleName: circleName,
        upcomingDate: upcomingDate,
      );

      NotificationsNotifier.notifyNextRoundUser(circleName: circleName,nextRoundDatetime: upcomingDate,recipientUsername: recipiendName,nextUserRoundId: nextUserRoundId );
      NotificationsNotifier.notifyPaymentDone(circleName: circleName,facilitatorName: createdBy,fromUserId:userId);
      NotificationsNotifier.notifyPayoutDone(circleName:circleName,toUserId: userId);
      NotificationsNotifier.notifyPayoutMarked(circleName: circleName,fromUsername:userPayName,facilitatorId: accessToken);
      payments.insert(0, _payment);
      loading = false;
      return accessToken;
    } else {
      loading = false;
      return null;
    }
  }

  Future<String> deletePayment({
    @required accessToken,
    @required paymentId,
  }) async {
    loading = true;
    var $response;
    try {
      $response = await PaymentFirestoreDatabase.deletePayment(
        paymentId: paymentId,
      );
    } catch (e) {}
    if ($response) {
      // todo remvove from list
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
    payments = [];
    notifyListeners();
  }
}
