import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:golak/arguments/orderPeopleArguments.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/header.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/payment.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/richReordrableList.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/elements/styledAlertDialog.dart';
import 'package:golak/elements/styledLoader.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/models/user.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class ListPeoplePage extends StatefulWidget {
  @override
  _ListPeopleState createState() => _ListPeopleState();
}
class _ListPeopleState extends State<ListPeoplePage>{


  final List<int> _orders = [];
  @override
  void initState() {
    super.initState();
    for (final i in List(12).asMap().keys) {
      _orders.add(i);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    final circlesNotifier = Provider.of<CirclesNotifier>(context);

    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final String _accessToken = authenticationNotifier.accessToken;

    final OrderPeopleArguments arguments =
        ModalRoute.of(context).settings.arguments;

    final User _user = authenticationNotifier.user;

    final List<Map> _users = [];
    final List<int> _filtredOrders = _orders
        .where((int _order) => _order < arguments.emails.length)
        .toList();
    for (final _order in _filtredOrders) {
      _users.add({
        'name': arguments.names[_order],
        'email': arguments.emails[_order],
        'phone': arguments.phones[_order],
      });
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: Stack(
        children: <Widget>[
            Column(
              children: <Widget>[
                Header(
                  title: FlutterI18n.translate(context, "order_people"),
                ),
                SizedBox(height: 32)
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 32.0 - 8),
                Padding(
                  key: ValueKey('Complete'),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: RoundedButton(
                      label: FlutterI18n.translate(context, "complete"),
                      labelSize: 15,
                      onPressed: () async {
                        // todo:save circle reoganaze
                      },
                      isSmall: true,
                    ),
                  ),
                ),
                SizedBox(height: 32.0 - 8),
              ],
            ),
              for (final index in _users.asMap().keys)
                Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    key: ValueKey(_users[index]['email']),
                    title: Text('${_users[index]['name']}'.toUpperCase()),
                    subtitle: Container(
                      height: 125,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                  '${FlutterI18n.translate(context, "email")}: '),
                              Text(
                                '${_users[index]['email']}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  '${FlutterI18n.translate(context, "phone")}: '),
                              Text(
                                '${_users[index]['phone']}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  '${FlutterI18n.translate(context, "order")}: '),
                              Text(
                                '#${index + 1}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: Icon(Icons.reorder),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Archive',
                      color: Colors.blue,
                      icon: Icons.archive,
                      onTap: () => print('Archive'),
                    ),
                    IconSlideAction(
                      caption: 'Share',
                      color: Colors.indigo,
                      icon: Icons.share,
                      onTap: () => print('Share'),
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'More',
                      color: Colors.black45,
                      icon: Icons.more_horiz,
                      onTap: () => print('More'),
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => print('Delete'),
                    ),
            ],
          ),
          if (Provider.of<CirclesNotifier>(context).loading) StyledLoader(),
        ],
      ),
    );
  }

}
