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
  List<dynamic> involvedUsers;
  DateTime startDate;
  Round currentRound;

  Circle({
    this.id,
    this.createdById,
    this.name,
    this.minContrib,
    this.contribType,
    this.totalAmount,
    this.involvedUsers,
    this.startDate,
    this.currentRound,
  });

  Circle.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdById = json['createdById'],
        name = json['name'],
        minContrib = json['minContrib'],
        contribType = json['contribType'],
        totalAmount = json['totalAmount'],
        involvedUsers = json['involvedUsers'],
        startDate = DateTime.parse(json['startDate']),
        currentRound = json['currentRound'] != null
            ? Round.fromJson(json['currentRound'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdById': createdById,
        'name': name,
        'minContrib': minContrib,
        'contribType': contribType,
        'totalAmount': totalAmount,
        'involvedUsers': involvedUsers,
        'startDate': startDate?.toString(),
        'currentRound': currentRound?.toJson(),
      };
}

class Round {
  final String id;
  final String recipientId;
  final DateTime startDate;
  final DateTime endDate;
  double paymentsDoneSum;
  final paymentsDoneDetails;

  Round({
    this.id,
    this.recipientId,
    this.startDate,
    this.endDate,
    this.paymentsDoneSum,
    this.paymentsDoneDetails,
  });

  Round.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        recipientId = json['recipientId'],
        startDate = json['start_date'] != null
            ? DateTime.parse(json['start_date'])
            : null,
        endDate =
            json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
        paymentsDoneDetails = json['paymentsDoneDetails'],
        paymentsDoneSum = json['paymentsDoneSum'] != null
            ? double.parse(json['paymentsDoneSum']?.toString())
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'recipientId': recipientId,
        'start_date': startDate?.toString(),
        'end_date': endDate?.toString(),
        'paymentsDoneSum': paymentsDoneSum,
        'paymentsDoneDetails': paymentsDoneDetails,
      };
}
