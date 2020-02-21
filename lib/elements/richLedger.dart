import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/models/ledger.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class RichLedger extends StatelessWidget {
  RichLedger(this.ledger);
  final List<Ledger> ledger;

  @override
  Widget build(BuildContext context) {
    final headers = [
      FlutterI18n.translate(context, 'user_name'),
      FlutterI18n.translate(context, 'draw_date'),
      FlutterI18n.translate(context, 'paid'),
      FlutterI18n.translate(context, 'outstanding_amount'),
      FlutterI18n.translate(context, 'late_fees'),
      FlutterI18n.translate(context, 'credit_score'),
    ];
    final footers = [
      FlutterI18n.translate(context, "total"),
      '',
      ledger.length > 0
          ? '\$${ledger?.map((Ledger li) => li.paid)?.reduce((double l1Paid, double l2Paid) => l1Paid + l2Paid)?.toString() ?? ''}'
          : 'N/A',
      'N/A',
      'N/A',
      'N/A',
    ];

    final i18nNotifier = Provider.of<I18nNotifier>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              for (final header in headers)
                Container(
                  width: 99.78,
                  height: 39.88,
                  margin: EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF76D0B7),
                    borderRadius: BorderRadius.only(
                      topLeft: !i18nNotifier.rtl
                          ? headers.first == header
                              ? Radius.circular(7)
                              : Radius.zero
                          : headers.last == header
                              ? Radius.circular(7)
                              : Radius.zero,
                      topRight: i18nNotifier.rtl
                          ? headers.first == header
                              ? Radius.circular(7)
                              : Radius.zero
                          : headers.last == header
                              ? Radius.circular(7)
                              : Radius.zero,
                    ),
                  ),
                  child: Text(
                    header,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          for (final _gr in ledger)
            Row(
              children: <Widget>[
                for (final value in [
                  _gr.userName,
                  _gr.drawDate.toString().split(' ').first,
                  '\$${_gr.paid}',
                  '${_gr.outstandingAmount}',
                  '${_gr.lateFees}',
                  '${_gr.creditScore}',
                ])
                  Container(
                    width: 99.78,
                    height: 28.43,
                    margin: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF76D0B7),
                    ),
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          for (final _ in List(max(9 - ledger.length, 0)))
            Row(
              children: <Widget>[
                for (final _ in List(6))
                  Container(
                    width: 99.78,
                    height: 28.43,
                    margin: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF76D0B7),
                    ),
                    child: Container(
                      height: 2,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
              ],
            ),
          Row(
            children: <Widget>[
              for (final footer in footers)
                Container(
                  width: 99.78,
                  height: 39.88,
                  margin: EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF76D0B7),
                    borderRadius: BorderRadius.only(
                      bottomLeft: !i18nNotifier.rtl
                          ? footers.first == footer
                              ? Radius.circular(7)
                              : Radius.zero
                          : footers.last == footer
                              ? Radius.circular(7)
                              : Radius.zero,
                      bottomRight: i18nNotifier.rtl
                          ? footers.first == footer
                              ? Radius.circular(7)
                              : Radius.zero
                          : footers.last == footer
                              ? Radius.circular(7)
                              : Radius.zero,
                    ),
                  ),
                  child: Text(
                    footer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
