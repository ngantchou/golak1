import 'dart:convert';

import 'package:golak/network/configuration.dart';
import 'package:http/http.dart';

getPayments({
  String accessToken,
  String userId,
}) async {
  final url = '$baseUrl/payments/upcoming_payments/$userId';
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
    \n----->Error@payments:
    \n----->statusCode: ${response.statusCode}
    \n----->body: ${response.body}
    ''');
  }
}

createPayment({
  String roundId,
  String userId,
  String accessToken,
}) async {
  final url = '$baseUrl/payments';
  final response = await post(Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer $accessToken',
      },
      body: {
        'round': roundId,
        'from_user': userId,
      },
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    print('''
    \n----->Error@createPayment:
    \n----->statusCode: ${response.statusCode}
    \n----->body: ${response.body}
    ''');
  }
}

deletePayment({
  String paymentId,
  String accessToken,
}) async {
  final url = '$baseUrl/payments/$paymentId';
  final response = await delete(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 204) {
    return json.decode(response.body);
  } else {
    print('''
    \n----->Error@deletePayment:
    \n----->statusCode: ${response.statusCode}
    \n----->body: ${response.body}
    ''');
  }
}
