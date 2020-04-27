import 'dart:convert';

import 'package:golak/models/recentActivity.dart';
import 'package:golak/network/recentActivities.dart' as recentActivitiesNetwork;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentActivitiesNotifier with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool $loading) {
    _loading = $loading;
    notifyListeners();
  }

  List<RecentActivity> _recentActivities;
  List<RecentActivity> get recentActivities => _recentActivities;
  set recentActivities(List<RecentActivity> $recentActivities) {
    _recentActivities = $recentActivities;
    notifyListeners();

   /* if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
          'recentActivities',
          json.encode(_recentActivities.map((RecentActivity recentActivity) {
            return recentActivity.toJson();
          }).toList()),
        );
      });*/
  }

  init({rememberMe, accessToken, userId}) async {
    rememberMe = rememberMe;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedRecentActivities = prefs.getString('recentActivities');
    if (encodedRecentActivities != null) {
      final List<dynamic> jsonRecentActivities =
          json.decode(encodedRecentActivities);
      recentActivities = jsonRecentActivities.map((jsonRecentActivity) {
        return RecentActivity.fromJson(jsonRecentActivity);
      }).toList();
    }
    await getRecentActivities(
      accessToken: accessToken,
      userId: userId,
    );
  }

  Future<String> getRecentActivities(
      {@required accessToken, @required userId}) async {
    loading = true;
    var $response;
    try {
      $response = await recentActivitiesNetwork.getRecentActivities(
        accessToken: accessToken,
        userId: userId,
      );
    } catch (e) {}
    if ($response != null) {
      List<dynamic> jsonRecentActivities = $response['recentActivity'];
      final List<RecentActivity> $recentActivities =
          jsonRecentActivities.map((recentActivity) {
        return RecentActivity(
          amount: double.parse(recentActivity['amount'].toString()),
          title: recentActivity['title']['en'],
          paymentDate: recentActivity['paymentDate'],
        );
      }).toList();
      if ($recentActivities.length > 0)
        recentActivities = $recentActivities.reversed.toList();
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
    recentActivities = [];
    notifyListeners();
  }
}
