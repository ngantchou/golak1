import 'dart:async';

import 'package:flutter/material.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/screens/home.dart';
import 'package:golak/screens/notifications.dart';
import 'package:golak/screens/profile.dart';
import 'package:golak/store/notifiers/flowNotifier.dart';
import 'package:golak/store/notifiers/notificationsNotifier.dart';
import 'package:provider/provider.dart';

class GolakPage extends StatefulWidget {
  @override
  _GolakPageState createState() => _GolakPageState();
}

class _GolakPageState extends State<GolakPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final flowNotifier = Provider.of<FlowNotifier>(context);
    final _controller = flowNotifier.controller;

    final _animateToPage = flowNotifier.animateToPage;

    final notificationsNotifier = Provider.of<NotificationsNotifier>(context);
    if (notificationsNotifier.opening) {
      String currentRoute;
      Navigator.of(context).popUntil((route) {
        currentRoute = route.settings.name;
        return true;
      });
      Timer.run(() {
        if (currentRoute != '/')
          Navigator.of(context).popUntil(
            (_) => _.isFirst,
          );
        _animateToPage(1);
        notificationsNotifier.opening = false;
      });
    }

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (int page) {
          flowNotifier.currentPage = page;
        },
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          NotificationsPage(),
          ProfilePage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
    );
  }
}
