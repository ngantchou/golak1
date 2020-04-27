import 'dart:convert';

import 'package:golak/models/user.dart';

final struct = '''
{
  "id": "5d3598994dcd3f0017594904",
  "created_by": {
      "id": "5d3597dc4dcd3f0017594901"
  },
  "name": "Circle 1",
  "min_contrib": 50,
  "contrib_type": "daily",
  "total_amount": 1000,
  "num_users": 3,
  "involved_users": [
      "5d3597dc4dcd3f0017594901",
      "5d3598994dcd3f0017594902",
      "5d3598994dcd3f0017594903"
  ],
  "start_date": "2019-07-21T11:05:08.000Z",
  "createdAt": "2019-07-22T11:06:01.502Z",
  "updatedAt": "2019-07-22T11:06:01.502Z",
  "currentRound": {
      "id": "5d3598994dcd3f0017594906",
      "recipient": {
          "id": "5d3597dc4dcd3f0017594901"
      },
      "circle": "5d3598994dcd3f0017594904",
      "start_date": "2019-07-22T11:05:08.000Z",
      "end_date": "2019-07-23T11:05:07.000Z",
      "createdAt": "2019-07-22T11:06:01.533Z",
      "updatedAt": "2019-07-22T11:06:01.533Z",
      "paymentsDoneDetails": [
          {
              "_id": "5d359b5b8a8f46001752a0b7",
              "round": "5d3598994dcd3f0017594906",
              "from_user": "5d3598994dcd3f0017594902",
              "createdAt": "2019-07-22T11:17:47.755Z",
              "updatedAt": "2019-07-22T11:17:47.755Z",
              "__v": 0
          },
          {
              "_id": "5d35a5b0499230001757b361",
              "round": "5d3598994dcd3f0017594906",
              "from_user": "5d3598994dcd3f0017594903",
              "createdAt": "2019-07-22T12:01:52.671Z",
              "updatedAt": "2019-07-22T12:01:52.671Z",
              "__v": 0
          }
      ],
      "paymentsDoneSum": 100,
      "finalPaymentsAmount": 100
  }
}
''';

class Circle {
  String id;
  String createdById;
  String name;
  double minContrib;
  String contribType;
  double totalAmount;
  int numUsers;
  List<dynamic> involvedUsers;
  List<User> users;
  DateTime startDate;
  DateTime created_at;
  DateTime updated_at;
  Round currentRound;

  Circle({
    this.id,
    this.createdById,
    this.name,
    this.minContrib,
    this.contribType,
    this.totalAmount,
    this.involvedUsers,
    this.numUsers,
    this.users,
    this.startDate,
    this.currentRound,
    this.created_at,
    this.updated_at,
  });

  Circle.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        createdById = json['createdById'],
        name = json['name'],
        involvedUsers = json['involvedUsers'],
        minContrib = json['minContrib']!= null
            ? double.parse(json['minContrib']?.toString()):null,
        contribType = json['contribType'],
        numUsers = json['numUsers'],
        totalAmount = json['totalAmount']!= null
            ? double.parse(json['totalAmount']?.toString()):null,
        startDate =  DateTime.parse(json['startDate'].toDate().toString()),
        updated_at = DateTime.parse(json['updated_at'].toDate().toString()),
        created_at = DateTime.parse(json['created_at'].toDate().toString());

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdById': createdById,
        'name': name,
        'minContrib': minContrib,
        'contribType': contribType,
        'totalAmount': totalAmount,
        'involvedUsers': involvedUsers,
        'numUsers': numUsers,
        'startDate': startDate?.toString(),
        'created_at': created_at?.toString(),
        'updated_at': updated_at?.toString(),
        'currentRound': currentRound?.toJson(),
      };

  @override
  String toString() {
    return 'Circle{id: $id, createdById: $createdById, name: $name, minContrib: $minContrib, contribType: $contribType, totalAmount: $totalAmount, involvedUsers: $involvedUsers, startDate: $startDate, created_at: $created_at, updated_at: $updated_at, currentRound: $currentRound}';
  }

}

class Round {
   String id;
  final String recipientId;
  final DateTime startDate;
  final DateTime endDate;
  double paymentsDoneSum;
  var paymentsDoneDetails;
  final String circleId;
  final DateTime created_at;
  final DateTime updated_at;
  User recipiend;
  Round({
    this.id,
    this.recipientId,
    this.circleId,
    this.startDate,
    this.endDate,
    this.paymentsDoneSum,
    this.paymentsDoneDetails,
    this.created_at,
    this.updated_at,
  });

  Round.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        recipientId = json['recipientId'],
        circleId = json['circleId'],
        startDate = DateTime.parse(json['start_date']),
        paymentsDoneSum = 0,
        paymentsDoneDetails = null,
        created_at = DateTime.parse(json['created_at']),
        updated_at = DateTime.parse(json['updated_at']),
        endDate = DateTime.parse(json['end_date']);

  Map<String, dynamic> toJson() => {
        'recipientId': recipientId,
        'circleId': circleId,
        'start_date': startDate.toString(),
        'end_date': endDate.toString(),
        'created_at': created_at.toString(),
        'updated_at': updated_at.toString(),
      };

  @override
  String toString() {
    return 'Round{id: $id, recipientId: $recipientId, startDate: $startDate, endDate: $endDate, paymentsDoneSum: $paymentsDoneSum, paymentsDoneDetails: $paymentsDoneDetails, circleId: $circleId, created_at: $created_at, updated_at: $updated_at}';
  }

}
