import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golak/screens/ReorderPeople.dart';
import 'package:golak/screens/circleManager.dart';
import 'package:golak/screens/circleStats.dart';
import 'package:golak/screens/circles.dart';
import 'package:golak/screens/createCircle.dart';
import 'package:golak/screens/dashboard.dart';
import 'package:golak/screens/golak.dart';
import 'package:golak/screens/home.dart';
import 'package:golak/screens/invitePeople.dart';
import 'package:golak/screens/ledger.dart';
import 'package:golak/screens/listPeople.dart';
import 'package:golak/screens/login.dart';
import 'package:golak/screens/notifications.dart';
import 'package:golak/screens/orderPeople.dart';
import 'package:golak/screens/profile.dart';
import 'package:golak/screens/recentActivities.dart';
import 'package:golak/screens/signup.dart';
import 'package:golak/screens/upcomingPayments.dart';
import 'package:golak/screens/upcomingPayouts.dart';
import 'package:golak/screens/welcome.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:golak/store/store.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(Golak());
}

class Golak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      child: MaterialApp(
        localizationsDelegates: [
          FlutterI18nDelegate(
            useCountryCode: false,
            fallbackFile: 'en',
            path: 'locales',
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'Golak',
        initialRoute: '/welcome',
        routes: {
          '/': (context) => GolakPage(),
          '/welcome': (context) => WelcomePage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/home': (context) => HomePage(),
          '/circles': (context) => CirclesPage(),
          '/circle-manager': (context) => CircleManagerPage(),
          '/circle-stats': (context) => CircleStatsPage(),
          '/circle-list': (context) => ListPeoplePage(),
          '/create-circle': (context) => CreateCirclePage(),
          '/dashboard': (context) => DashboardPage(),
          '/invite-people': (context) => InvitePeoplePage(),
          '/order-people': (context) => OrderPeoplePage(),
          '/reorder-people': (context) => ReoderPeoplePage(),
          '/ledger': (context) => LedgerPage(),
          '/profile': (context) => ProfilePage(),
          '/others-profile': (context) => ProfilePage(),
          '/notifications': (context) => NotificationsPage(),
          '/upcoming-payments': (context) => UpcomingPayments(),
          '/upcoming-payouts': (context) => UpcomingPayouts(),
          '/recent-activities': (context) => RecentActivities(),
        },
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
        ),
        builder: (BuildContext context, Widget rootWidget) {
          final i18nNotifier = Provider.of<I18nNotifier>(context);

          return Directionality(
            textDirection: i18nNotifier.currentLang == 'ar' ||
                    i18nNotifier.currentLang == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: rootWidget,
          );
        },
      ),
    );
  }
}
