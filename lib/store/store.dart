import 'package:flutter/material.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/flowNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/store/notifiers/ledgerNotifier.dart';
import 'package:golak/store/notifiers/notificationsNotifier.dart';
import 'package:golak/store/notifiers/paymentsNotifier.dart';
import 'package:golak/store/notifiers/payoutsNotifier.dart';
import 'package:golak/store/notifiers/recentActivitiesNotifier.dart';
import 'package:provider/provider.dart';

class StoreProvider extends StatefulWidget {
  final Widget child;
  StoreProvider({this.child});

  @override
  Store createState() => Store();
}

class Store extends State<StoreProvider> {
  static AuthenticationNotifier authenticationNotifier =
      AuthenticationNotifier()..rememberMe = true;

  static CirclesNotifier circlesNotifier = CirclesNotifier()..circles = [];
  static PaymentsNotifier paymentsNotifier = PaymentsNotifier()..payments = [];

  static PayoutsNotifier payoutsNotifier = PayoutsNotifier()..payouts = [];

  static NotificationsNotifier notificationsNotifier = NotificationsNotifier()
    ..notifications = [];

  static RecentActivitiesNotifier recentActivitiesNotifier =
      RecentActivitiesNotifier()..recentActivities = [];

  static LedgerNotifier ledgerNotifier = LedgerNotifier();

  static I18nNotifier i18nNotifier = I18nNotifier();

  static FlowNotifier flowNotifier = FlowNotifier();
  bool isAuthenticated = false;
  @override
  void initState() {
    super.initState();


    initDataSources();
    authenticationNotifier.initDataSources = initDataSources;
    i18nNotifier.init();
  }

  Future<void> initDataSources({rememberMe = false}) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final isAuthenticated = prefs.getString('accessToken') != null &&
    //     prefs.getString('user') != null;
    // if (!isAuthenticated) return;

    if (authenticationNotifier.user == null) {
      await authenticationNotifier.init();
      if (authenticationNotifier.user == null) return;
    }

    flowNotifier.init();
    await circlesNotifier.init(
      rememberMe: rememberMe,
      accessToken: authenticationNotifier.accessToken,
      userId: authenticationNotifier.user.id,
    );
    notificationsNotifier.initOneSignal(authenticationNotifier.accessToken);
    await paymentsNotifier.init(
      rememberMe: rememberMe,
      accessToken: authenticationNotifier.accessToken,
      userId: authenticationNotifier.user.id,
    );
    await payoutsNotifier.init(
      rememberMe: rememberMe,
      accessToken: authenticationNotifier.accessToken,
      userId: authenticationNotifier.user.id,
    );
    await notificationsNotifier.init(
      rememberMe: rememberMe,
      accessToken: authenticationNotifier.accessToken,
      userId: authenticationNotifier.user.id,
    );
    await recentActivitiesNotifier.init(
      rememberMe: rememberMe,
      accessToken: authenticationNotifier.accessToken,
      userId: authenticationNotifier.user?.id,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationNotifier>(
          builder: (_) => authenticationNotifier,
        ),
        ChangeNotifierProvider<CirclesNotifier>(
          builder: (_) => circlesNotifier,
        ),
        ChangeNotifierProvider<PaymentsNotifier>(
          builder: (_) => paymentsNotifier,
        ),
        ChangeNotifierProvider<PayoutsNotifier>(
          builder: (_) => payoutsNotifier,
        ),
        ChangeNotifierProvider<NotificationsNotifier>(
          builder: (_) => notificationsNotifier,
        ),
        ChangeNotifierProvider<RecentActivitiesNotifier>(
          builder: (_) => recentActivitiesNotifier,
        ),
        ChangeNotifierProvider<FlowNotifier>(
          builder: (_) => flowNotifier,
        ),
        ChangeNotifierProvider<LedgerNotifier>(
          builder: (_) => ledgerNotifier,
        ),
        ChangeNotifierProvider<I18nNotifier>(
          builder: (_) => i18nNotifier,
        ),
      ],
      child: widget.child,
    );
  }
}
