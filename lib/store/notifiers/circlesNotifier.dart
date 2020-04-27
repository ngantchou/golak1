import 'dart:convert';

import 'package:golak/firestore_database/circle_fs_db.dart';
import 'package:golak/firestore_database/round_fs_db.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/user.dart';
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
    users: [],
    // final DateTime startDate;
    startDate: DateTime.now(),
    // final Round currentRound;
  );
  Circle get newCircle => _newCircle;
  set newCircle(Circle $newCircle) {
    _newCircle = $newCircle;
    notifyListeners();
  }
  List<Round> _rounds;

  List<Round> get rounds => _rounds;

  set rounds(List<Round> value) {
    _rounds = value;
    //notifyListeners();
  }

  List<Circle> _circles;
  List<Circle> get circles => _circles;
  set circles(List<Circle> $circles) {
    _circles = $circles;
    notifyListeners();

    /*if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
          'circles',
          json.encode(_circles.map((Circle circle) {
            return circle.toJson();
          }).toList()),
        );
      });*/

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
     List<Circle>  $circles;
    try {
      $circles = (await CircleFirestoreDatabase.getCirclesList(
         accessToken,
      )) as List<Circle>;
    } catch (e) {}
    if ($circles != null) {

      if ($circles.length > 0) circles = $circles.reversed.toList();
      loading = false;
      return accessToken;
    } else {
      loading = false;
      return null;
    }
  }
  Future<String> getRounds({@required circleId}) async {
    loading = true;
    List<Round>  $rounds=[];
    try {
     RoundFirestoreDatabase.getUserIDRoundForCircle(
        circleId: circleId,
      ).listen((data) async {
       for(var d in data) {
         $rounds.add(await d);
       }
      });
    } catch (e) {}
    if ($rounds != null) {

      if ($rounds.length > 0) rounds = $rounds.reversed.toList();
      loading = false;
      return circleId;
    } else {
      loading = false;
      return null;
    }
  }

  Future<String> addParticipant({ accessToken,User involvedUsers,  circleId}) async {
    loading = true;
    var $response;
    try{
      $response = await CircleFirestoreDatabase.addParticipant (
          accessToken: accessToken,
          user: involvedUsers,
          circleId: circleId
      );
      loading = false;
      return $response.toString() ;
    }catch(e){
      loading = false;
      print('$e');
    }
  }

  Future<List<User>> getUserpaid(
      {@required accessToken, @required circleId}) async {
    // loading = true;
    var $response;
    try {
      $response = await circlesNetwork.getUserpaid(
        accessToken: accessToken,
        circleId: circleId,
      );
    } catch (e) {}
    if ($response != null) {
      print("user paid: ${$response['rows']}");
      List<dynamic> jsonLedgerRows = $response['rows'];
      final List<User> $ledger = jsonLedgerRows.map((ledger) {
        return User.fromJson(ledger);
      }).toList();
      List<User> _ledger = [];
      if ($ledger.length > 0) _ledger = $ledger.reversed.toList();
      // loading = false;
      return _ledger;
    } else {
      // loading = false;
      return null;
    }
  }
  Future<String> deleteRoundCircles({@required userId, @required circleId }) async {
    loading = true;
    var $response;
    //print(email);
    try {
      $response = await CircleFirestoreDatabase.deleteParticipant(
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
    Circle response;
    try {
      response = await CircleFirestoreDatabase.createCircle(
        accessToken: accessToken,
        name: newCircle.name,
        minContrib: newCircle.minContrib,
        contribType: newCircle.contribType,
        totalAmount: newCircle.totalAmount,
        involvedUsers: newCircle.users,
        startDate: newCircle.startDate,
      );
    } catch (e) {
      print('exception : $e');
    }
    if (response != null) {
    /*  newCircle = Circle(
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
              : null);*/
      print(response);
      circles.insert(0, response);
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
