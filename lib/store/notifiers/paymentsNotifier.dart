import 'dart:convert';

import 'package:golak/models/payment.dart';
import 'package:golak/network/payments.dart' as paymentsNetwork;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentsNotifier with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool $loading) {
    _loading = $loading;
    notifyListeners();
  }

  List<Payment> _payments;
  List<Payment> get payments => _payments;
  set payments(List<Payment> $payments) {
    _payments = $payments;
    notifyListeners();

    if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
          'payments',
          json.encode(_payments.map((Payment payment) {
            return payment.toJson();
          }).toList()),
        );
      });
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
    var $response;
    try {
      $response = await paymentsNetwork.getPayments(
        accessToken: accessToken,
        userId: userId,
      );
    } catch (e) {}
    if ($response != null) {
      List<dynamic> jsonPayments = $response['rows'];
      final List<Payment> $payments = jsonPayments.map((payment) {
        return Payment.fromJson(payment);
      }).toList();
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
    @required userId,
    @required roundId,
    @required amount,
    @required circleName,
    @required upcomingDate,
  }) async {
    loading = true;
    var $response;
    try {
      $response = await paymentsNetwork.createPayment(
        accessToken: accessToken,
        userId: userId,
        roundId: roundId,
      );
    } catch (e) {}
    if ($response != null) {
      final Payment _payment = Payment(
        amount: amount,
        circleName: circleName,
        upcomingDate: upcomingDate,
      );
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
      $response = await paymentsNetwork.deletePayment(
        accessToken: accessToken,
        paymentId: paymentId,
      );
    } catch (e) {}
    if ($response != null) {
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
