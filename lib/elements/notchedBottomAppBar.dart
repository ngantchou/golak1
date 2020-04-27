import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/firestore_database/notifications_fs_db.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/flowNotifier.dart';
import 'package:golak/store/notifiers/notificationsNotifier.dart';
import 'package:provider/provider.dart';
import 'package:golak/models/notification.dart' as model;

class NotchedBottomAppBar extends StatelessWidget {
  const NotchedBottomAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentRoute;
    Navigator.of(context).popUntil((route) {
      currentRoute = route.settings.name;
      return true;
    });

    final flowNotifier = Provider.of<FlowNotifier>(context);
    final _animateToPage = flowNotifier.animateToPage;
    final _page = flowNotifier.currentPage;
    final notificationsNotifier = Provider.of<NotificationsNotifier>(context);
    final int _notifications =
        notificationsNotifier.unreadNotifCount;
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final String _accessToken = authenticationNotifier.accessToken;

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8 * 1.0,
          left: 8 * 3.0,
          right: 8 * 3.0,
          bottom: 8 * 1.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                if (currentRoute != '/')
                  Navigator.of(context).popUntil(
                    (_) => _.isFirst,
                  );
                _animateToPage(0);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GolakIcon(
                  GolakIcons.home,
                  color: _page == 0.0 ? Color(0xFF76D0B7) : Color(0xFFA5A4AA),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (currentRoute != '/')
                  Navigator.of(context).popUntil(
                    (_) => _.isFirst,
                  );
                _animateToPage(1);
              },
              child: Container(
                width: 30,
                height: 30,
                child: Stack(
                  children: [
                    GolakIcon(
                      GolakIcons.reminders,
                      color: _page == 1.0 ? Color(0xFF76D0B7) : Color(0xFFA5A4AA),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 5),
                      child: StreamBuilder(
                        stream:NotificationFirestoreDatabase
                            .getCountUnreadNotifications(_accessToken),
                          builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                          bool notif=false;
                          if(snapshot.hasData && snapshot.data!=null && snapshot.data.length>0 ){
                            for(var i in snapshot.data){
                              if(i!=null){
                                notif=true;
                              }
                            }
                            }
                          if(notif){
                           return Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border: Border.all(color: Colors.white, width: 1)),
                          );}else
                            return Container();
                          }),
                    ),
                  ],
                ),
              ),/*Padding(
                padding: const EdgeInsets.all(8.0),
                child: GolakIcon(
                  GolakIcons.reminders,
                  color: _page == 1.0 ? Color(0xFF76D0B7) : Color(0xFFA5A4AA),
                ),
              ),*/
            ),
            InkWell(
              onTap: () {
                if (currentRoute != '/')
                  Navigator.of(context).popUntil(
                    (_) => _.isFirst,
                  );
                _animateToPage(2);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GolakIcon(
                  GolakIcons.personOutline,
                  color: _page == 2.0 ? Color(0xFF76D0B7) : Color(0xFFA5A4AA),
                ),
              ),
            ),
            SizedBox(width: 45),
          ],
        ),
      ),
    );
  }
}
