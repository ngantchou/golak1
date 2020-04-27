import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/arguments/invitePeopleArguments.dart';
import 'package:golak/arguments/orderPeopleArguments.dart';
import 'package:golak/elements/PeopleCircleListView.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/payment.dart';
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
    int i =0;
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
          circle.users.length>3?Align(
            alignment: Alignment.center,
            child: Container(
              width: 108.01,
              height: 108.01,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF76D0B7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (circle.currentRound != null &&
                      circle.currentRound.startDate != null) ...[
                    Text(
                      FlutterI18n.translate(context, "pot_amount"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${circle.minContrib*circle.users.length ?? '0'} USD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${FlutterI18n.translate(context, "starts_on")} \n${circle.currentRound?.startDate?.toString()?.split(' ')?.first ?? ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 7,
                        color: Colors.white,
                      ),
                    ),
                  ] else
                    Text(
                      'Information not available',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ):Container(),
          if(circle.users.length<=3)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            child: PeopleCircle(
              circle: circle,
            )
          )
          else
          ...circle.users.map((user) {
           i++;
            final _paid = circle.currentRound != null &&
                circle.currentRound.paymentsDoneDetails != null &&
                circle.currentRound.paymentsDoneDetails.where((payment) {
                  return payment['from_user'] == user.id;
                }).length >
                    0;
           return Container(
             padding: EdgeInsets.symmetric(vertical: 8),
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
             child: Row(
               children: <Widget>[
                 SizedBox(width: 16),
                 Center(
                   child: Container(

                     child: InkWell(
                         onTap: () =>
                             Navigator.of(context).pushNamed('/others-profile',
                                 arguments: User(
                                   id: user.id,
                                   username: user.username,
                                   email: user.email,
                                   phone: user.phone,
                                   country: user.country,
                                   image: user.image,
                                 )),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Container(
                               decoration: BoxDecoration(
                                 color: Colors.grey,
                                 shape: BoxShape.circle,
                                 border: Border.all(
                                   width: 2,
                                   color: Color(0xFF76D0B7),
                                 ),
                                 image: DecorationImage(
                                   fit: BoxFit.cover,
                                   image: AssetImage(
                                     'images/person.jpg',
                                   ),
                                 ),
                               ),
                               height: 70,
                               width: 70,
                               child: ClipOval(
                                 child: user.image != null &&
                                     user.image != ''
                                     ? Image.network(
                                   user.image,
                                   fit: BoxFit.cover,
                                 )
                                     : Container(),
                               ),
                             ),

                           ],
                         )
                     ),
                   ),
                 ),
                 SizedBox(width: 16),
                 Expanded(
                   child: Text(
                     '${user.username}',
                     overflow: TextOverflow.ellipsis,
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.w700,
                       color: Color(0xFF75CFB6),
                     ),
                   ),
                 ),
                 Spacer(),
                 Container(
                   width: 111.5,
                   height: 32.1,
                   child: Text('Rank Order: $i'),
                 ),
                 SizedBox(width: 16),
               ],
             ),
           );
          }),
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
