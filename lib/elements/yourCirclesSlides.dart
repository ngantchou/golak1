import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/styledLoader.dart';
import 'package:golak/firestore_database/circle_fs_db.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class YourCirclesSlides extends StatelessWidget {


  Widget EmptyCircleWidget( BuildContext context,i18nNotifier){

    return Container(
      height: 205,
      width: 150,
      margin: EdgeInsets.only(
        right: 0,
        top: 8,
        bottom: 16,
        left: 0,
      ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF76D0B7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(.1),
          ),
        ],
      ),
      alignment: i18nNotifier.rtl
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            FlutterI18n.translate(
              context,
              "latest_circles_will_be_shown_here",
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Text(
            FlutterI18n.translate(
              context,
              "create_your_first_circle",
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          NotchedFAB(
            heroTag: 'your-circles',
          ),
        ],
      ),
    );
  }
  Widget CircleWidget( BuildContext context,i18nNotifier,Circle circle){
    return Container(
      height: 205,
      width: MediaQuery.of(context).size.width/1.2,
      margin: EdgeInsets.only(
        right: i18nNotifier.rtl ? 0 : 16,
        top: 8,
        bottom: 16,
        left: i18nNotifier.rtl ? 16 : 0,
      ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF76D0B7),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            circle.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (circle?.currentRound?.endDate != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                    '${FlutterI18n.translate(context, "pay_by")}: ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text:
                    '${circle?.currentRound?.endDate?.toString()?.split(' ')?.first ?? ''}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                    '${FlutterI18n.translate(context, "completed")}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    if (circle?.currentRound?.endDate != null) ...[
                      TextSpan(
                        text:
                        '\$${circle.currentRound?.paymentsDoneSum * circle.minContrib ?? '0'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                        '/\$${circle.minContrib * circle.users.length}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      TextSpan(
                        text:
                        '\$${circle.minContrib * circle.users.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                        '/${FlutterI18n.translate(context, "in_total")}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              Spacer(),
              if (circle?.currentRound?.endDate != null)
                Text(
                  '\$${circle.minContrib} EMI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: circle.currentRound==null?0:(circle.currentRound?.paymentsDoneSum * circle.minContrib ?? 0) /
                  (circle.minContrib * circle.involvedUsers.length),
              backgroundColor: Color(0xFF6FBCA9),
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                (circle?.currentRound?.endDate != null)
                    ? FlutterI18n.translate(context, "total_amount")
                    : '',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                (circle?.currentRound?.endDate != null)
                    ? FlutterI18n.translate(
                  context,
                  circle.contribType == 'daily'
                      ? 'today'
                      : (circle.contribType == 'weekly'
                      ? 'this_week'
                      : (circle.contribType == 'bi-weekly'
                      ? 'this_bi_week'
                      : 'this_month')),
                )
                    : '',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              LimitedBox(
                maxWidth: 16.0 * 3 + 16.0,
                maxHeight: 31,
                child: Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    ...circle.users
                        .asMap()
                        .map((index, user) {
                      return index<3?MapEntry(
                        index,
                        Positioned(
                          top: 0,
                          left:
                          !i18nNotifier.rtl ? index * 15.0 : null,
                          right:
                          i18nNotifier.rtl ? index * 15.0 : null,
                          child: Container(
                            width: 31,
                            height: 31,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'images/person.jpg',
                                ),
                              ),
                            ),
                            child: ClipOval(
                              child: user.image !=
                                  null &&
                                  user.image != ''
                                  ? Image.network(
                                user.image,
                                fit: BoxFit.cover,
                              )
                                  : Container(),
                            ),
                          ),
                        ),
                      ):MapEntry(
                          index,
                          Container());
                    }).values
                  ],
                ),
              ),
              SizedBox(width: 16),
              circle.users.length>3?Text(
                '+${circle.users.length-3} ${FlutterI18n.translate(context, 'member')}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ):Text(''),
              Spacer(),
              LimitedBox(
                maxWidth: 100,
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: .75,
                      color: Colors.white70,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FlatButton(
                    color: Color(0xFF83D5BE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed(
                        (circle?.currentRound?.endDate != null)
                            ? '/circle-manager'
                            : '/circle-stats',
                        arguments: circle),
                    child: Text(
                      FlutterI18n.translate(
                          context,
                          (circle?.currentRound?.endDate != null)
                              ? "pay_now"
                              : "circle_stats"),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final circlesNotifier = Provider.of<CirclesNotifier>(context);
    //final List<Circle> _circles = circlesNotifier.circles;
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final String _accessToken = authenticationNotifier.accessToken;

    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return Container(
      height: 205 + 24.0,
      child: PageView(
        controller: PageController(
          viewportFraction: .92,
        ),
        scrollDirection: Axis.horizontal,
        children: <Widget>[

              StreamBuilder(
              stream: CircleFirestoreDatabase.getCirclesList(_accessToken),
              builder: (context, AsyncSnapshot<List<Future<Circle>>> circleSP) {

                if(circleSP.hasData && circleSP.data.length>0)
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(2.0),
                  primary: false,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: circleSP.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(future: circleSP.data[index],
                        builder: (BuildContext context, AsyncSnapshot result) {
                          Circle circle = result.data as Circle;

                          if(circle!=null)
                            return CircleWidget(context,i18nNotifier,circle);
                          return Container(
                            height: 50,
                            width: 50,
                            child: StyledLoader(),
                          );
                        });
                  },
                );
                else
                return EmptyCircleWidget(context,i18nNotifier);
              })
        ],
      ),
    );
  }
}
