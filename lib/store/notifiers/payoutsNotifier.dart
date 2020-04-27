import 'dart:convert';

import 'package:golak/models/payout.dart';
import 'package:golak/network/payouts.dart' as payoutsNetwork;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayoutsNotifier with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool $loading) {
    _loading = $loading;
    onChange();
  }
  void onChange() {
    notifyListeners();
  }
  List<Payout> _payouts;
  List<Payout> get payouts => _payouts;
  set payouts(List<Payout> $payouts) {
    _payouts = $payouts;
    onChange();

    if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
          'payouts',
          json.encode(_payouts.map((Payout payout) {
            return payout.toJson();
          }).toList()),
        );
      });
  }

  init({rememberMe, accessToken, userId}) async {
    rememberMe = rememberMe;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedPayouts = prefs.getString('payouts');
    if (encodedPayouts != null) {
      final List<dynamic> jsonPayouts = json.decode(encodedPayouts);
      payouts = jsonPayouts.map((jsonPayout) {
        return Payout.fromJson(jsonPayout);
      }).toList();
    }
    await getPayouts(
      accessToken: accessToken,
      userId: userId,
    );
  }

  Future<String> getPayouts({@required accessToken, @required userId}) async {
    loading = true;
    var $response;
    try {
      $response = await payoutsNetwork.getPayouts(
        accessToken: accessToken,
        userId: userId,
      );
    } catch (e) {}
    if ($response != null) {
      List<dynamic> jsonPayouts = $response['rows'];
      final List<Payout> $payouts = jsonPayouts.map((payout) {
        return Payout.fromJson(payout);
      }).toList();
      if ($payouts.length > 0) payouts = $payouts.reversed.toList();
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
    payouts = [];
    notifyListeners();
  }
}
