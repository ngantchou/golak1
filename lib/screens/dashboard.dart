import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/arguments/invitePeopleArguments.dart';
import 'package:golak/arguments/orderPeopleArguments.dart';
import 'package:golak/elements/PeopleCircleListView.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/peopleCircle.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/user.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:pdf/widgets.dart' as prefix0;
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Circle circle = ModalRoute.of(context).settings.arguments;
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    final circlesNotifier = Provider.of<CirclesNotifier>(context);
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final String _accessToken = authenticationNotifier.accessToken;
    bool _randomSlots = false;
    bool _participate = false;
    String _numberOfPeople = '1';
    List<User> userspay;
    String end_date = null ;
    switch(circle.contribType){
      case "monthly" : end_date = DateTime(circle.startDate.year, circle.startDate.month +circle.users.length , circle.startDate.day).toString().split(' ').first;break;
      case "dayly" : end_date = DateTime(circle.startDate.year, circle.startDate.month, circle.startDate.day +circle.users.length).toString().split(' ').first;break;
      case "bi-weekly" : end_date = DateTime(circle.startDate.year, circle.startDate.month +circle.users.length , circle.startDate.day + 3*circle.users.length).toString().split(' ').first;break;
      case "weekly" : end_date = DateTime(circle.startDate.year, circle.startDate.month +circle.users.length , circle.startDate.day + 7*circle.users.length).toString().split(' ').first;break;
    }

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
                horizontal: 22,
                vertical: 4,
              ),
              child: Text('${FlutterI18n.translate(context, "Pot Amount : ${circle.minContrib*circle.users.length}")}',
              )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 4,
            ),
            child: Text('Start date : ${circle.startDate.toString().split(' ').first}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 4,
            ),
            child: Text('End date : ${ DateTime(circle.startDate.year, circle.startDate.month +circle.users.length , circle.startDate.day).toString().split(' ').first}',
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            child: circle.users.length<=3?PeopleCircle(
              circle: circle,
            ):PeopleCircleListView(
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
          _accessToken==circle.createdById?Center(
            child: RoundedButton(
              label: FlutterI18n.translate(context, "order_people"),
              labelSize: 15,
              icon: GolakIcons.people,
              onPressed: () async {
                  final List<String> _names = circle.users
                      .sublist(0, circle.users.length)
                      .map((User data) => data.username )
                      .toList();
                  final List<String> _emails = circle.users
                      .sublist(0, circle.users.length)
                      .map((User data) => data.email )
                      .toList();
                  final List<String> _phones = circle.users
                      .sublist(0, circle.users.length)
                      .map((User data) => data.phone )
                      .toList();
                  final List<String> _ids = circle.users
                      .sublist(0, circle.users.length)
                      .map((User data) => data.id )
                      .toList();
                  final List<bool> _isPay = circle.users
                      .sublist(0, circle.users.length)
                      .map((User data) => data.isPay )
                      .toList();
                  //userspay = await circlesNotifier.getUserpaid(accessToken: _accessToken, circleId: circle.id);
                  Navigator.of(context).pushNamed(
                    '/reorder-people',
                    arguments: OrderPeopleArguments(
                      ids:  _ids,
                      names:  _names,
                      emails:_emails,
                      phones: _phones,
                      randomSlots: false,
                      isPay: _isPay,
                      circle :circle,
                      userspaiy: userspay,
                    ),
                  );
              },
              isSmall: true,
            ),
          ):Container(),
          _accessToken==circle.createdById?SizedBox(height: 32):Container(),
          _accessToken==circle.createdById?Center(
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
          ):Container(),
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
