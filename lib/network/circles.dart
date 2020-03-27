import 'dart:convert';

import 'package:golak/network/configuration.dart';
import 'package:http/http.dart';

getCircles({
  String accessToken,
  String userId,
}) async {
  final url = '$baseUrl/users/$userId/circles';
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('''
    \n----->Error@circles:
    \n----->statusCode: ${response.statusCode}
    \n----->body: ${response.body}
    ''');
  }
}

createCircle({
  String accessToken,
  String name,
  double minContrib,
  String contribType,
  double totalAmount,
  List involvedUsers,
  DateTime startDate,
}) async {
  final url = '$baseUrl/circles';
  final response = await post(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": 'Bearer $accessToken',
    },
    body: {
      'name': name,
      'min_contrib': minContrib.toString(),
      'contrib_type': contribType.toString().toLowerCase(),
      'total_amount': totalAmount.toString(),
      'num_users': involvedUsers.length.toString(),
      'involved_users': json.encode(involvedUsers),
      'start_date': startDate.toString(),
    },
    encoding: Encoding.getByName("utf-8"),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('''
    \n----->Error@createCirlce:
    \n----->statusCode: ${response.statusCode}
    \n----->body: ${response.body}
    ''');
  }
}
addParticipant({
  String accessToken,
  List involvedUsers,
  String circleId,
}) async {
  final url = '$baseUrl/circles/$circleId';
  print('add participant: $baseUrl/circles/$circleId');
  final response = await put(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": 'Bearer $accessToken',
    },
    body: {
      'involved_users': json.encode(involvedUsers),
    },
    encoding: Encoding.getByName("utf-8"),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('''
    \n----->Error@addParticipantCirlce:
    \n----->statusCode: ${response.statusCode}
    \n----->body: ${response.body}
    ''');
  }
}
deleteRoundCircle({
  String accessToken,
  String circleId,
  String userId,
  String email,
  String phone
  }) async {
  final url = '$baseUrl/circles/$circleId';
  print('$baseUrl/circles/$circleId   $email');
  final response = await put(
  Uri.parse(url),
  headers: {
  "Accept": "application/json",
  "Authorization": 'Bearer $accessToken',
  },
    body: {
      'name': email,
    },
    encoding: Encoding.getByName("utf-8"),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
  print('''
      \n----->Error@circles:
      \n----->statusCode: ${response.statusCode}
      \n----->body: ${response.body}
      ''');
  }

}
getUserpaid({
  String accessToken,
  String circleId,
}) async {
  final url = '$baseUrl/circles/$circleId/userpaid';
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('''
    \n----->Error@ledger:
    \n----->statusCode: ${response.statusCode}
    \n----->body: ${response.body}
    ''');
  }
}