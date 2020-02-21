import 'dart:convert';

import 'package:golak/network/configuration.dart';
import 'package:http/http.dart';

getPayouts({
  String accessToken,
  String userId,
}) async {
  final url = '$baseUrl/payments/upcoming_payouts/$userId';
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
    \n----->Error@payouts:
    \n----->statusCode: ${response.statusCode}
    \n----->body: ${response.body}
    ''');
  }
}
