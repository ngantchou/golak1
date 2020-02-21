import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/richStat.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class CircleStatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    final Circle circle = ModalRoute.of(context).settings.arguments;

    final circleStats = [
      {
        'title': FlutterI18n.translate(context, "minimum_contribution"),
        'image': 'images/minimum-contribution@3x.png',
        'value': '\$${circle.minContrib}',
      },
      {
        'title': FlutterI18n.translate(context, "contribution_type"),
        'image': 'images/minimum-contribution@3x.png',
        'value': '${circle.contribType}',
      },
      {
        'title': FlutterI18n.translate(context, "total_amount"),
        'image': 'images/total-amount@3x.png',
        'value': '\$${circle.involvedUsers.length * circle.minContrib}',
      },
      {
        'title': FlutterI18n.translate(context, "number_of_people"),
        'image': 'images/number-of-people@3x.png',
        'value': '${circle.involvedUsers.length}',
      },
      {
        'title': FlutterI18n.translate(context, "start_date"),
        'image': 'images/start-date@3x.png',
        'value': '${circle.startDate.toString().split(' ').first}'
      },
      {
        'title': FlutterI18n.translate(context, "end_date"),
        'image': 'images/start-date@3x.png',
        'value':
            circle.currentRound != null && circle.currentRound.endDate != null
                ? '${circle.currentRound.endDate.toString().split(' ').first}'
                : 'unavailable',
      },
    ];
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          RichHeader(
            title:
                '${circle.name} \n${FlutterI18n.translate(context, "circle_stats")}',
          ),
          SizedBox(height: 8 * 2.0),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: <Widget>[
              ...circleStats.map((stat) {
                return RichStat(
                  title: stat['title'],
                  image: stat['image'],
                  value: stat['value'],
                );
              }),

            ],
          ),
          SizedBox(height: 32),
          Center(
            child: RoundedButton(
              label: FlutterI18n.translate(context, "back"),
              labelSize: 15,
              icon: GolakIcons.back,
              onPressed: () => Navigator.of(context).pop(),
              isSmall: true,
            ),
          ),
          SizedBox(height: 8 * 9.0),
        ],
      ),
    );
  }
}
