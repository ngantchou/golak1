import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/arguments/orderPeopleArguments.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/header.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/richReordrableList.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/elements/styledAlertDialog.dart';
import 'package:golak/elements/styledLoader.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class OrderPeoplePage extends StatefulWidget {
  @override
  _OrderPeoplePageState createState() => _OrderPeoplePageState();
}

class _OrderPeoplePageState extends State<OrderPeoplePage> {
  final List<int> _orders = [];
  bool _paid = false;
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

    final List<Map> _users = [];
    final List<int> _filtredOrders = _orders
        .where((int _order) => _order < arguments.emails.length)
        .toList();
    for (final _order in _filtredOrders) {
      _users.add({
        'isPay': arguments.isPay[_order],
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
                 if (arguments.randomSlots)
                  Padding(
                    key: ValueKey('Randomize'),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: RoundedButton(
                        label: FlutterI18n.translate(context, "randomize"),
                        labelSize: 15,
                        onPressed: () {
                          final _factory =
                              Timer.periodic(Duration(milliseconds: 100), (_) {
                            _orders.sort(
                              (_, __) =>
                                  Random().nextInt(55) - Random().nextInt(55),
                            );
                            setState(() {});
                          });
                          Timer(Duration(milliseconds: 500), () {
                            print("ici eforf test degorge we ");
                            _factory.cancel();
                          });
                        },
                        isSmall: true,
                      ),
                    ),
                  ),
                Padding(
                  key: ValueKey('Complete'),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: RoundedButton(
                      label: FlutterI18n.translate(context, "complete"),
                      labelSize: 15,
                      onPressed: () async {
                        if (arguments.circle == null) {
                        for (final _index in _users
                            .asMap()
                            .keys) {
                          circlesNotifier.newCircle.involvedUsers[_index] = ({
                            'name': _users[_index]['name'],
                            'email': _users[_index]['email'],
                            "order": _index + 1,
                            "isPay":_users[_index]['isPay'],
                          });
                        }

                          Circle $circle = await circlesNotifier.createCircle(
                            accessToken: _accessToken,
                          );

                          if ($circle != null) {
                            Navigator.of(context).pushNamed(
                              '/dashboard',
                              arguments: circlesNotifier.newCircle,
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StyledAlertDialog(
                                    label: 'OK',
                                    title: 'Échec de la connexion',
                                    content: '',
                                    cancel: false,
                                    callback: () async {
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          }
                        }else{
                          for (final _index in _users
                              .asMap()
                              .keys) {
                            arguments.circle.involvedUsers.add({
                              'name': _users[_index]['name'],
                              'email': _users[_index]['email'],
                              "order": _index + 1,
                              "isPay":_users[_index]['isPay'],
                            });
                          }
                          //todo ajouter le code pour l'invitation d'un membre;
                          final $addPartCircle = await circlesNotifier.addParticipant (
                              accessToken: _accessToken,
                              involvedUsers: arguments.circle.involvedUsers,
                              circleId: arguments.circle.id
                          );
                          if ($addPartCircle != null) {
                            for (final _index in _users
                                .asMap()
                                .keys) {
                              arguments.circle.involvedUsers.add({
                                'name': _users[_index]['name'],
                                'email': _users[_index]['email'],
                                "order": _index + 1,
                              });
                            }
                            Navigator.of(context).pushNamed(
                              '/dashboard',
                              arguments: arguments.circle,
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StyledAlertDialog(
                                    label: 'OK',
                                    title: 'Échec de la connexion',
                                    content: '',
                                    cancel: false,
                                    callback: () async {
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          }
                        }

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
              for (final index in _users.asMap().keys)
                ListTile(
                  key: ValueKey(_users[index]['email']),
                  title: Text('${_users[index]['name']}'.toUpperCase()),
                  subtitle: Container(
                    height: 131,
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

                        Container(height: 2,color: Colors.white70,)
                      ],
                    ),
                  ),
                  trailing: Icon(Icons.reorder),
                ),
                /*ListTile(
                  key: ValueKey(_users[index]['email']),
                  title: RaisedButton(
                      onPressed: (){

                      },
                      child: Text("Received Payout ?"),
                  ),
                  trailing: Row(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: (){

                        },
                        child: Text("Yes"),
                      ),
                      RaisedButton(
                        onPressed: (){

                        },
                        child: Text("No"),
                      ),
                    ],
                  ),
                )*/
            ],
          ),
          if (Provider.of<CirclesNotifier>(context).loading) StyledLoader(),
        ],
      ),
    );
  }
}
