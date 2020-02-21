import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/user.dart';

class PeopleCircle extends StatelessWidget {
  PeopleCircle({
    Key key,
    @required this.circle,
  });
  final Circle circle;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints bx) {
        final _phoneWidth = min(bx.biggest.width, bx.biggest.height);
        final rCircle = 6.283;
        final baseAngle = rCircle /
            (circle.involvedUsers.length > 0 ? circle.involvedUsers.length : 1);
        return AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Align(
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
                            '${circle.currentRound?.paymentsDoneSum ?? '0'} USD',
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
                ),
                ...circle.involvedUsers.asMap().map((index, involvedUser) {
                  return MapEntry(
                    index,
                    Positioned(
                      top: _phoneWidth / 2 - 35,
                      left: _phoneWidth / 2 - 35,
                      child: Transform.translate(
                        offset: Offset.fromDirection(
                          baseAngle * index,
                          _phoneWidth / 2 - 35,
                        ),
                        child: InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/others-profile',
                                  arguments: User(
                                    id: involvedUser['id'],
                                    username: involvedUser['name'],
                                    email: involvedUser['email'],
                                    phone: involvedUser['mobile'],
                                    country: involvedUser['country'],
                                    image: involvedUser['picture'],
                                  )),
                          child: Column(
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
                                  child: involvedUser['picture'] != null &&
                                      involvedUser['picture'] != ''
                                      ? Image.network(
                                    involvedUser['picture'],
                                    fit: BoxFit.cover,
                                  )
                                      : Container(),
                                ),
                              ),
                              Text(involvedUser['name'])
                            ],
                          )
                        ),
                      ),
                    ),
                  );
                }).values,
              ],
            ),
          ),
        );
      },
    );
  }
}
