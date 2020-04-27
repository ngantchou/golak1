import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/notificationCard.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/firestore_database/notifications_fs_db.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/store/notifiers/notificationsNotifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:golak/models/notification.dart' as model;

class NotificationsPage extends StatelessWidget {

  @override

  @override
  Widget build(BuildContext context) {
    final notificationsNotifier = Provider.of<NotificationsNotifier>(context);
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final String _accessToken = authenticationNotifier.accessToken;
     List<model.Notification> _notifications =
        notificationsNotifier.notifications;
    //notificationsNotifier.onChange();
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    final df = new DateFormat('MM-dd-yyyy');
    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(0),
      children: <Widget>[
        RichHeader(title: null),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionTitle(
              text: FlutterI18n.translate(context, "notifications"),
              fontSize: 25),
        ),

        SizedBox(height: 8 * 2.0),
        StreamBuilder(
            stream: NotificationFirestoreDatabase.getNotifications(_accessToken),
            builder: (BuildContext context, AsyncSnapshot<List<model.Notification>> snapshot) {
              if(snapshot.hasData && snapshot.data.length>0)
                return ListView.builder(
                  //scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(2.0),
                  primary: false,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {

                          return  GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 15),
                              child: NotificationCard(
                                text: snapshot.data[index].message,
                                date: snapshot.data[index].created_at.toString().split(' ').first,
                                seen: snapshot.data[index].seen,
                              ),
                            ),
                            onTap: () async {
                              snapshot.data[index].seen  = await notificationsNotifier.markAsRead(notificationId: snapshot.data[index].id);

                            },
                          );

                  },
                );
                    //model.Notification notification = snapshot.data[i];


              return
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                      child: Text(
                        FlutterI18n.translate(
                          context,
                          'notifications_related_to_important_events_will_be_listed_here',
                        ),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
            }

        )
      ]
    );
  }
}
