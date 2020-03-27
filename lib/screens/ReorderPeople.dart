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

class ReoderPeoplePage extends StatefulWidget {
  @override
  _ReoderPeopleState createState() => _ReoderPeopleState();
}
class _ReoderPeopleState extends State<ReoderPeoplePage>{


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
     List<String>  id_user = new List<String>();
     for(User u in arguments.userspaiy){
       id_user.add(u.id);
     }
     print(id_user);
    final List<int> _filtredOrders = _orders
        .where((int _order) => _order < arguments.emails.length)
        .toList();

   // arguments.circle.involvedUsers.remove(arguments.userspaiy)

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: Stack(
        children: <Widget>[
          RichReorderableListView(
            header: Column(
              children: <Widget>[
                Header(
                  title: FlutterI18n.translate(context, "order_people"),
                ),
                SizedBox(height: 32)
              ],
            ),
            footer: Column(
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
                        Navigator.pop(context);
                      },
                      isSmall: true,
                    ),
                  ),
                ),
                SizedBox(height: 32.0 - 8),
              ],
            ),
            onReorder: (oI, nI) => setState(
                  () {
                if (nI > oI) nI -= 1;
                _orders.insert(
                    nI, _orders.removeAt(_orders.indexOf(_filtredOrders[oI])));
              },
            ),
            children: <Widget>[
              ...arguments.circle.involvedUsers.asMap().map((index, _users) {
                print(id_user.contains(_users['id']));
                print((_users['_id']));
                if(id_user.contains(_users['_id'])==false)
                return MapEntry(
                  index,
                  Slidable(
                    key: ValueKey(index),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      key: ValueKey(_users['email']),
                      title: Text('${_users['name']}'.toUpperCase()),
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
                                  '${_users['email']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                    '${FlutterI18n.translate(context, "phone")}: '),
                                Text(
                                  '${_users['phone']}',
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
                    secondaryActions: <Widget>[
                      IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,

                          onTap: () async {
                            // ToDO: adding delete round inside circle
                            print(_users['_id']);
                            final $round = await circlesNotifier.deleteRoundCircles(
                                accessToken: _accessToken,
                                phone: _users['phone'],
                                userId: _user.id,
                                email: _users['email'],
                                circleId: _users['circle']
                            );
                            print($round);
                            /*setState(() {
                          arguments.emails.removeAt(index);
                        });*/
                          }
                      ),
                    ],
                  ),
                );
                else
                  return MapEntry(index, Container(key:Key(_users['_id'])));
              }).values,
            ],
          ),
          if (Provider.of<CirclesNotifier>(context).loading) StyledLoader(),
        ],
      ),
    );
  }

}
