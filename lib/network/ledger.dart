import 'dart:convert';

import 'package:golak/network/configuration.dart';
import 'package:http/http.dart';

getLedger({
  String accessToken,
  String circleId,
}) async {
  final url = '$baseUrl/circles/$circleId/ledger';
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
