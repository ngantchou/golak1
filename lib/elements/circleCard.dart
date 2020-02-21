import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/models/circle.dart';

/*
CircleCard(
  title: '',
),
*/
class CircleCard extends StatelessWidget {
  CircleCard({Key key, @required this.circle}) : super(key: key);
  final Circle circle;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 150,
      margin: EdgeInsets.only(
        right: 16,
        top: 8,
        bottom: 8,
        left: 16,
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            circle.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (circle?.currentRound?.endDate != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${FlutterI18n.translate(context, "pay_by")}: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${circle?.currentRound?.endDate?.toString()?.split(' ')?.first ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
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
                    text: '${FlutterI18n.translate(context, "completed")}',
                    style: TextStyle(
                      color: Colors.black87,
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
                        text: '\$${circle.currentRound.paymentsDoneSum ?? 0}/',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\$${circle.minContrib * circle.involvedUsers.length}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      TextSpan(
                        text:
                            '\$${circle.minContrib * circle.involvedUsers.length}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '/${FlutterI18n.translate(context, "in_total")}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 8),
          if (circle?.currentRound?.endDate != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (circle.currentRound?.paymentsDoneSum ?? 0) /
                    (circle.minContrib * circle.involvedUsers.length),
                backgroundColor: Color(0xFFE5E5E5),
                valueColor: AlwaysStoppedAnimation(Color(0xFF6FBCA9)),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 1,
                backgroundColor: Color(0xFFE5E5E5),
                valueColor: AlwaysStoppedAnimation(Color(0xFF6FBCA9)),
              ),
            ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              LimitedBox(
                maxWidth: 76,
                maxHeight: 31,
                child: Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    ...circle.involvedUsers.asMap().map((index, involvedUser) {
                      return MapEntry(
                          index,
                          Positioned(
                            top: 0,
                            left: index * 15.0,
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
                                child: involvedUser['picture'] != null &&
                                        involvedUser['picture'] != ''
                                    ? Image.network(
                                        involvedUser['picture'],
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                              ),
                            ),
                          ));
                    }).values,
                  ],
                ),
              ),
              Spacer(),
              Container(
                height: 35,
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   width: .75,
                  //   color: Colors.white70,
                  // ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FlatButton(
                  color: Color(0xFF83D5BE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: (circle?.currentRound?.endDate != null)
                      ? () => Navigator.of(context).pushNamed(
                            '/circle-manager',
                            arguments: circle,
                          )
                      : () => Navigator.of(context).pushNamed(
                            '/circle-stats',
                            arguments: circle,
                          ),
                  child: Text(
                    FlutterI18n.translate(
                        context,
                        (circle?.currentRound?.endDate != null)
                            ? "manage"
                            : "circle_stats"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
}
