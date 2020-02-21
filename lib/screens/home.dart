import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/upcomingPaymentsSlides.dart';
import 'package:golak/elements/yourCirclesSlides.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/elements/upcommingPayoutsList.dart';
import 'package:golak/models/user.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/store/notifiers/paymentsNotifier.dart';
import 'package:golak/store/notifiers/payoutsNotifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final User _user = authenticationNotifier.user;
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        RichHeader(title: null),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionTitle(
            text: FlutterI18n.translate(context, "hello"),
            fontSize: 25,
          ),
        ),
        SizedBox(height: 8 * 1.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionTitle(
            text: '${_user?.username ?? '...'},'.toUpperCase(),
            fontSize: 25,
            color: Color(0xFF494856),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            FlutterI18n.translate(context, "overview"),
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF98989D),
            ),
          ),
        ),
        SizedBox(height: 8 * 2.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Consumer<CirclesNotifier>(
            builder: (context, circlesNotifier, _) => SectionTitle(
              text: FlutterI18n.translate(context, "your_circles"),
              isExpandable: true,
              length: circlesNotifier.circles.length,
              onPressed: () => Navigator.of(context).pushNamed('/circles'),
            ),
          ),
        ),
        YourCirclesSlides(),
        SizedBox(height: 8 * 2.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Consumer<PaymentsNotifier>(
            builder: (context, paymentsNotifier, _) => SectionTitle(
              text: FlutterI18n.translate(context, "upcoming_payments"),
              isExpandable: true,
              length: paymentsNotifier.payments.length,
              onPressed: () =>
                  Navigator.of(context).pushNamed('/upcoming-payments'),
            ),
          ),
        ),
        UpcomingPaymentsSlides(),
        SizedBox(height: 8 * 0.5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Consumer<PayoutsNotifier>(
            builder: (context, payoutsNotifier, _) => SectionTitle(
              text: FlutterI18n.translate(context, "upcoming_payouts"),
              isExpandable: true,
              length: payoutsNotifier.payouts.length,
              onPressed: () =>
                  Navigator.of(context).pushNamed('/upcoming-payouts'),
            ),
          ),
        ),
        SizedBox(height: 8 * 2.0),
        UpcomingPayoutsCards(),
        SizedBox(height: 8 * 2.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionTitle(
            text: FlutterI18n.translate(context, "other"),
          ),
        ),
        SizedBox(height: 8 * 2.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: <Widget>[
              RoundedButton(
                label: FlutterI18n.translate(context, "manage_circles"),
                labelSize: 11,
                icon: GolakIcons.circle,
                iconSize: 15,
                isSmall: true,
                isShrink: true,
                onPressed: () => Navigator.of(context).pushNamed('/circles'),
              ),
              RoundedButton(
                label: FlutterI18n.translate(context, "create_new_circles"),
                labelSize: 11,
                icon: GolakIcons.circleAdd,
                iconSize: 15,
                isSmall: true,
                isShrink: true,
                onPressed: () =>
                    Navigator.of(context).pushNamed('/create-circle'),
              ),
            ],
          ),
        ),
        SizedBox(height: 8 * 9.0),
      ],
    );
  }
}
