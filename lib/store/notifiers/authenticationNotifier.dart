import 'dart:convert';
import 'package:golak/models/user.dart';
import 'package:golak/network/authentication.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationNotifier with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool $loading) {
    _loading = $loading;
    notifyListeners();
  }

  String _accessToken;
  String get accessToken => _accessToken;
  set accessToken(String $accessToken) {
    _accessToken = $accessToken;
    notifyListeners();

    if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('accessToken', _accessToken);
      });
  }

  User _user;
  User get user => _user;

  set user(User $user) {
    _user = $user;
    notifyListeners();

    if (rememberMe)
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
            'user', _user != null ? json.encode(_user.toJson()) : null);
      });
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    final encodedUser = prefs.getString('user');
    if (encodedUser == null) return;
    user = User.fromJson(
      json.decode(encodedUser),
    );
    notifyListeners();
  }

  Future<User> login({@required email, @required password}) async {
    loading = true;
    var $response;
    try {
      $response = await auth.login(email: email, password: password);
    } catch (e) {
      print('error@loging: $e');
    }
    if ($response != null) {
      accessToken = $response['token'];
      print(accessToken);
      user = User(
        id: $response['user']['id'],
        username: $response['user']['name'],
        image: $response['user']['picture'],
        phone: $response['user']['mobile'],
        country: $response['user']['country'],
        email: $response['user']['email'],
      );
      loading = false;
      initDataSources(
        rememberMe: rememberMe,
      ); // todo: toggle this
      return user;
    } else {
      loading = false;
      return null;
    }
  }

  signup({
    @required username,
    @required email,
    @required password,
    @required phone,
    @required country,
  }) async {
    loading = true;
    try {
      final $response = await auth.signup(
        username: username,
        email: email,
        password: password,
        phone: phone,
        country: country,
      );
      if ($response != null) {
        loading = false;
        return $response;
      }
    } catch (e) {
      print('Error while signing up ${e.toString()}');
    }

    loading = false;
  }

  updateProfilePicture({
    @required userId,
    @required picture,
  }) async {
    loading = true;
    try {
      final $response = await auth.updateProfilePicture(
        userId: userId,
        picture: picture,
        accessToken: accessToken,
      );
      if ($response != null) {
        user = User(
          id: user.id,
          username: user.username,
          email: user.email,
          phone: user.phone,
          country: user.country,
          image: picture,
        );
        notifyListeners();
        loading = false;
        return $response;
      }
    } catch (e) {
      print('Error while updating profile picture ${e.toString()}');
    }

    loading = false;
  }

  updateOnesignalPlayerId({
    @required playerId,
  }) async {
    loading = true;
    try {
      final $response = await auth.updateOnesignalPlayerId(
        userId: user?.id,
        playerId: playerId,
        accessToken: accessToken,
      );
      if ($response != null) {
        notifyListeners();
        loading = false;
        return $response;
      }
    } catch (e) {
      print('Error while updating oneSignal playerid ${e.toString()}');
    }
    loading = false;
  }

  AsyncCallback _initDataSources;
  get initDataSources => _initDataSources;
  set initDataSources($initDataSources) {
    _initDataSources = $initDataSources;
    notifyListeners();
  }

  clean({playerId}) async {
    await updateOnesignalPlayerId(playerId: playerId);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', null);
    prefs.setString('user', null);
    prefs.setString('circles', null);
    prefs.setString('notifications', null);
    prefs.setString('payments', null);
    prefs.setString('payouts', null);
    prefs.setString('recentActivities', null);
    await prefs.clear();
    accessToken = null;
    user = null;
    // todo: clean notifiers
    notifyListeners();
  }

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;
  set rememberMe(bool $rememberMe) {
    _rememberMe = $rememberMe;
    notifyListeners();
  }
}
