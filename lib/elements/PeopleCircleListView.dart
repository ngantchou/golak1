import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/user.dart';

class PeopleCircleListView extends StatelessWidget {
  PeopleCircleListView({
    Key key,
    @required this.circle,
  });
  final Circle circle;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Column(
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
          ),
          ...circle.users.asMap().map((index, user) {
            return MapEntry(
              index,
              ListTile(
                title: Container(

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
                subtitle: Text(user.username),
                trailing: Container(
                  child: Text('Rank Order: ${index+1}' ),
                ),
              ),
            );
          }).values,
        ],
      ),
    );
  }
}
