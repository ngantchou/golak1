import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/notificationCard.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/store/notifiers/notificationsNotifier.dart';
import 'package:provider/provider.dart';
import 'package:golak/models/notification.dart' as model;

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationsNotifier = Provider.of<NotificationsNotifier>(context);
    final List<model.Notification> _notifications =
        notificationsNotifier.notifications;
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        RichHeader(title: null),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionTitle(
              text: FlutterI18n.translate(context, "notifications"),
              fontSize: 25),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: SectionTitle(
        //     text: FlutterI18n.translate(context, "recent_activity"),
        //     isExpandable: true,
        //     color: Color(0xFF494856),
        //   ),
        // ),
        SizedBox(height: 8 * 2.0),
        if (_notifications.length > 0)
          for (final notification in _notifications) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: NotificationCard(
                text: notification.message,
                date: notification.createdAt.toString().split(' ').first,
              ),
            ),
            SizedBox(height: 8 * 2.0),
          ]
        else
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
          ),
        SizedBox(height: 8 * 9.0),
      ],
    );
  }
}
