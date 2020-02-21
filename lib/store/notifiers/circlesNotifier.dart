import 'dart:convert';

import 'package:golak/models/circle.dart';
import 'package:golak/network/circles.dart' as circlesNetwork;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CirclesNotifier with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool $loading) {
    _loading = $loading;
    notifyListeners();
  }

  final circleStruct = '''
{
	"name": "Circle 1", !!!!!!
	"min_contrib": "50",  !!!!!!
	"contrib_type": "daily",  !!!!!!
	"total_amount": "1000", !!!!!!
	"num_users": "3",
	"involved_users": [
		{"name": "User 1", "email": "user1@gmail.com", "order": 2},
		{"name": "User 2", "mobile": "0554739265", "order": 3},
		{"name": "User 3", "email": "user3@gmail.com", "order": 1}
	],
	"start_date": "2019-07-21T11:05:08+0000"
}
''';
  Circle _newCircle = Circle(
    // final String id;
    // final String createdById;
    // final String name;
    name: '',
    // final double minContrib;
    minContrib: 0,
    // final String contribType;
    contribType: 'Monthly',
    // final double totalAmount;
    totalAmount: 0,
    // final List<dynamic> involvedUsers;
    involvedUsers: [],
    // final DateTime startDate;
    startDate: DateTime.now(),
    // final Round currentRound;
  );
  Circle get newCircle => _newCircle;
  set newCircle(Circle $newCircle) {
    _newCircle = $newCircle;
    notifyListeners();
  }

  List<Circle> _circles;
  List<Circle> get circles => _circles;
  set circles(List<Circle> $circles) {
    _circles = $circles;
    notifyListeners();

    if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
          'circles',
          json.encode(_circles.map((Circle circle) {
            return circle.toJson();
          }).toList()),
        );
      });
  }

  init({rememberMe, accessToken, userId}) async {
    rememberMe = rememberMe;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedCircles = prefs.getString('circles');
    if (encodedCircles != null) {
      final List<dynamic> jsonCircles = json.decode(encodedCircles);
      circles = jsonCircles.map((jsonCircle) {
        return Circle.fromJson(jsonCircle);
      }).toList();
    }
    getCircles(
      accessToken: accessToken,
      userId: userId,
    );
  }

  Future<String> getCircles({@required accessToken, @required userId}) async {
    loading = true;
    var $response;
    try {
      $response = await circlesNetwork.getCircles(
        accessToken: accessToken,
        userId: userId,
      );
    } catch (e) {}
    if ($response != null) {
      List<dynamic> jsonCircles = $response['circles'];
      final List<Circle> $circles = jsonCircles
          .where((circle) => circle['currentRound'] != null)
          .map((circle) {
        return Circle(
            id: circle['id'],
            createdById: circle['created_by']['id'],
            name: circle['name'],
            minContrib: double.parse(circle['min_contrib'].toString()),
            contribType: circle['contrib_type'],
            totalAmount: double.parse(circle['total_amount'].toString()),
            involvedUsers: circle['involved_users'],
            startDate: DateTime.parse(circle['start_date'].toString()),
            currentRound: Round.fromJson(circle['currentRound']));
      }).toList();
      if ($circles.length > 0) circles = $circles.reversed.toList();
      loading = false;
      return accessToken;
    } else {
      loading = false;
      return null;
    }
  }

  Future<String> deleteRoundCircles({@required accessToken, @required phone,@required userId, @required email, @required circleId }) async {
    loading = true;
    var $response;
    //print(email);
    try {
      $response = await circlesNetwork.deleteRoundCircle(
        accessToken: accessToken,
        phone : phone,
        email: email,
        circleId: circleId,
          userId: userId,
      );
      if ($response != null) {
        loading = false;
        return $response;
      }else{
        loading = false;
        return null;
      }
    } catch (e) {
      print('Error while delete round ${e.toString()}');
    }
  }

  Future<Circle> createCircle({
    @required String accessToken,
  }) async {
    loading = true;
    var $response;
    try {
      $response = await circlesNetwork.createCircle(
        accessToken: accessToken,
        name: newCircle.name,
        minContrib: newCircle.minContrib,
        contribType: newCircle.contribType,
        totalAmount: newCircle.totalAmount,
        involvedUsers: newCircle.involvedUsers,
        startDate: newCircle.startDate,
      );
    } catch (e) {
      print('$e');
    }
    if ($response != null) {
      newCircle = Circle(
          id: $response['id'],
          createdById: $response['created_by']['id'],
          name: $response['name'],
          minContrib: double.parse($response['min_contrib'].toString()),
          contribType: $response['contrib_type'],
          totalAmount: double.parse($response['total_amount'].toString()),
          involvedUsers: $response['involved_users'],
          startDate: DateTime.parse($response['start_date'].toString()),
          currentRound: $response['currentRound'] != null
              ? Round.fromJson($response['currentRound'])
              : null);
      circles.insert(0, newCircle);
      loading = false;
      return newCircle;
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
    circles = [];
    notifyListeners();
  }
}
