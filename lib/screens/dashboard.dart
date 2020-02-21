import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/arguments/invitePeopleArguments.dart';
import 'package:golak/arguments/orderPeopleArguments.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/peopleCircle.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Circle circle = ModalRoute.of(context).settings.arguments;
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    bool _randomSlots = false;
    bool _participate = false;
    String _numberOfPeople = '1';
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          RichHeader(
            title:
                '${circle.name} \n${FlutterI18n.translate(context, "dashboard")}',
          ),
          SizedBox(height: 8 * 2.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            child: PeopleCircle(
              circle: circle,
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: RoundedButton(
              label: FlutterI18n.translate(context, "circle_stats"),
              labelSize: 15,
              icon: GolakIcons.statistics,
              onPressed: () => Navigator.of(context).pushNamed(
                '/circle-stats',
                arguments: circle,
              ),
              isSmall: true,
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: RoundedButton(
              label: FlutterI18n.translate(context, "order_people"),
              labelSize: 15,
              icon: GolakIcons.people,
              onPressed: () {
                  final List<String> _names = circle.involvedUsers
                      .sublist(0, circle.involvedUsers.length)
                      .map((dynamic data) => data['name'] as String)
                      .toList();
                  final List<String> _emails = circle.involvedUsers
                      .sublist(0, circle.involvedUsers.length)
                      .map((dynamic data) => data['email'] as String)
                      .toList();
                  final List<String> _phones = circle.involvedUsers
                      .sublist(0, circle.involvedUsers.length)
                      .map((dynamic data) => data['phone'] as String)
                      .toList();
                  Navigator.of(context).pushNamed(
                    '/reorder-people',
                    arguments: OrderPeopleArguments(
                      names:  _names,
                      emails:_emails,
                      phones: _phones,
                      randomSlots: true,
                      circle :circle,
                    ),
                  );
              },
              isSmall: true,
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: RoundedButton(
              label: FlutterI18n.translate(context, "invite_people"),
              labelSize: 15,
              icon: GolakIcons.people,
              onPressed: () => Navigator.of(context).pushNamed(
                '/invite-people',
                arguments: InvitePeopleArguments(
                  numberOfPeople: int.parse(
                    _numberOfPeople,
                  ),
                  circle : circle,
                  randomSlots: _randomSlots,
                  participate: _participate,
                ),
              ),
              isSmall: true,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: RoundedButton(
              label: FlutterI18n.translate(context, "complete"),
              labelSize: 15,
              icon: GolakIcons.checkCircle,
              iconColor: null,
              onPressed: () async {
                // await circlesNotifier.createCircle(
                //   accessToken: null, // todo: complete circle creation
                // );
                Navigator.of(context).popUntil(
                  (_) => _.isFirst,
                );
              },
              isSmall: true,
            ),
          ),
          SizedBox(height: 8 * 9.0),
        ],
      ),
    );
  }
}
