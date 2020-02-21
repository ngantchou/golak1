import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/models/payment.dart';
import 'package:golak/store/notifiers/paymentsNotifier.dart';
import 'package:provider/provider.dart';

/*
final _upcomingPayments = [
  {
    'title': 'Start a Business',
    'date': '25 Dec, 2019',
    'price': '\$20',
  },
]
RichSlides(
  slides: _upcomingPayments,
),
*/
class UpcomingPaymentsSlides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentsNotifier = Provider.of<PaymentsNotifier>(context);
    final List<Payment> _payments = paymentsNotifier.payments;
    return Container(
      height: 180 + 24.0,
      child: ListView(
        padding: EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          if (_payments.length > 0)
            ..._payments
                .sublist(0, min(_payments.length, 5))
                .map((Payment payment) {
              return Container(
                height: 180,
                width: 150,
                margin: EdgeInsets.only(right: 16, top: 8, bottom: 16),
                padding: EdgeInsets.all(16),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 8 * 6.0,
                      child: Text(
                        payment.circleName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 34,
                      width: 66,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFF76D0B7),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '\$${payment.amount.toString()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      FlutterI18n.translate(context, "due"),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      payment.upcomingDate.toString().split(' ').first,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF484855),
                      ),
                    ),
                  ],
                ),
              );
            })
          else
            Container(
              height: 180,
              width: 150,
              margin: EdgeInsets.only(right: 16, top: 8, bottom: 16),
              padding: EdgeInsets.all(16),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(
                        context, "you_dont_have_payments_yet"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
