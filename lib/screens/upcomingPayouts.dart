import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/richCard.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/models/payout.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/store/notifiers/payoutsNotifier.dart';
import 'package:provider/provider.dart';

class UpcomingPayouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final payoutsNotifier = Provider.of<PayoutsNotifier>(context);
    final List<Payout> _payouts = payoutsNotifier.payouts;
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          RichHeader(title: null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SectionTitle(
                text: FlutterI18n.translate(context, "upcoming_payouts"),
                fontSize: 25),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: SectionTitle(
          //     text: FlutterI18n.translate(context, "recent_activity"),
          //     isExpandable: true,
          //     color: Color(0xFF494856),
          //   ),
          // ),
          SizedBox(height: 8 * 2.0),
          if (_payouts.length > 0)
            for (final payout in _payouts) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RichCard(
                  title: payout.circleName,
                  subTitle: payout.upcomingDate.toString().split(' ').first,
                  trailing: payout.amount.toString(),
                ),
              ),
              SizedBox(height: 12),
            ]
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      color: Colors.black.withOpacity(.1),
                    ),
                  ],
                ),
                child: Text(
                  FlutterI18n.translate(context, "you_dont_have_payouts_yet"),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          SizedBox(height: 8 * 9.0),
        ],
      ),
    );
  }
}
