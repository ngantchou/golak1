import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/richCard.dart';
import 'package:golak/models/payout.dart';
import 'package:golak/store/notifiers/payoutsNotifier.dart';
import 'package:provider/provider.dart';

class UpcomingPayoutsCards extends StatelessWidget {
  const UpcomingPayoutsCards({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final payoutsNotifier = Provider.of<PayoutsNotifier>(context);
    final List<Payout> _payouts = payoutsNotifier.payouts;

    return Column(
      children: <Widget>[
        if (_payouts.length > 0)
          for (final payment
              in _payouts.sublist(0, min(_payouts.length, 5))) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RichCard(
                title: payment.circleName,
                subTitle: payment.upcomingDate.toString().split(' ').first,
                trailing: payment.amount.toString(),
              ),
            ),
            SizedBox(height: 12),
          ]
        else
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
      ],
    );
  }
}
