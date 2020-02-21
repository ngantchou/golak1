import 'dart:convert';

import 'package:golak/network/configuration.dart';
import 'package:http/http.dart';

getNotifications({
  String accessToken,
  String userId,
}) async {
  final url = '$baseUrl/users/$userId/notifications';
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
    \n----->Error@notifications:
    \n----->statusCode: ${response.statusCode}
    \n----->body: ${response.body}
    ''');
  }
}
