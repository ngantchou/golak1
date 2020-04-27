import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/payment.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class CircleManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Circle circle = ModalRoute.of(context).settings.arguments;
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          RichHeader(
            title: '${circle.name}',
          ),
          SizedBox(height: 8 * 2.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SectionTitle(
              text:
                  '${FlutterI18n.translate(context, "current_round")}${circle?.currentRound?.startDate != null ? ':  ' + circle?.currentRound?.startDate?.toString()?.split(' ')?.first : ''}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SectionTitle(
              text:circle?.currentRound?.recipiend?.username
            ),
          ),
          SizedBox(height: 8 * 2.0),
          ...circle.users.map((user) {
            final _paid = circle.currentRound != null &&
                circle.currentRound.paymentsDoneDetails != null &&
                circle.currentRound.paymentsDoneDetails.where((payment) {
                      return payment['from_user'] == user.id;
                    }).length >
                    0;
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: Payment(
                name: user.username ?? user.email,
                image: user.image,
                paid: _paid,
                paymentId: _paid
                    ? circle.currentRound.paymentsDoneDetails.where((payment) {
                        return payment['from_user'] == user.id;
                      }).first['id']
                    : null,
                userId: user.id,
                amount: circle.minContrib,
                upcomingDate: circle.currentRound?.startDate,
                circleName: circle.name,
                circleId: circle.id,
                createdBy: circle.name,
                recipiendName: circle.currentRound?.recipiend?.username,
                nextUserRoundId: circle.currentRound?.recipientId,
                roundId: circle.currentRound?.id,
              ),
            );
          }),
          SizedBox(height: 32),
          Center(
            child: RoundedButton(
              label: FlutterI18n.translate(context, "circle_dashboard"),
              labelSize: 15,
              icon: GolakIcons.statistics,
              onPressed: () => Navigator.of(context)
                  .pushNamed('/dashboard', arguments: circle),
              isSmall: true,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: RoundedButton(
              label: FlutterI18n.translate(context, "ledger"),
              labelSize: 15,
              icon: GolakIcons.ledger,
              onPressed: () =>
                  Navigator.of(context).pushNamed('/ledger', arguments: circle),
              isSmall: true,
            ),
          ),
          SizedBox(height: 8 * 9.0),
        ],
      ),
    );
  }
}
