import 'dart:convert';
import 'package:golak/network/configuration.dart';
import 'package:http/http.dart';

login({
  String email,
  String password,
}) async {
  final url = '$baseUrl/auth';
  final response = await post(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
    },
    body: {'email': email, 'password': password},
    encoding: Encoding.getByName("utf-8"),
  );

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    print('Error@login: ${response.body}');
  }
}

updateProfilePicture({
  String userId,
  String picture,
  String accessToken,
}) async {
  final url = '$baseUrl/users/$userId/picture';
  final response = await put(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken",
    },
    body: {'picture': picture},
    encoding: Encoding.getByName("utf-8"),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('Error@updateProfilePicture: ${response.body}');
  }
}

signup({
  String username,
  String email,
  String password,
  String phone,
  String country,
}) async {
  final url = '$baseUrl/Users';
  print(url);
  final response = await post(Uri.parse(url),
      headers: {
        "Accept": "application/json",
      },
      body: {
        'name': username,
        'mobile': phone,
        'country': country,
        'email': email,
        'password': password,
        'picture':
            'https://firebasestorage.googleapis.com/v0/b/golak-3a756.appspot.com/o/default-user-icon-4.jpg?alt=media&token=aff5d71a-b26b-4ac7-b142-b229ef099cfb'
      },
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    print('Error@signup: ${response.body}');
  }
}

updateOnesignalPlayerId({
  String userId,
  String playerId,
  String accessToken,
}) async {
  final url = '$baseUrl/users/$userId/onesignal_player_id';
  final response = await put(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken",
    },
    body: {'onesignal_player_id': playerId},
    encoding: Encoding.getByName("utf-8"),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('Error@updateProfilePicture: ${response.body}');
  }
}
