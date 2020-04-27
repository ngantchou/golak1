import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/profileCard.dart';
import 'package:golak/elements/richCard.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/elements/styledAlertDialog.dart';
import 'package:golak/elements/styledLoader.dart';
import 'package:golak/firestore_database/user_fs_db.dart';
import 'package:golak/models/recentActivity.dart';
import 'package:golak/models/user.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/flowNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/store/notifiers/notificationsNotifier.dart';
import 'package:golak/store/notifiers/paymentsNotifier.dart';
import 'package:golak/store/notifiers/payoutsNotifier.dart';
import 'package:golak/store/notifiers/recentActivitiesNotifier.dart';
import 'package:golak/utils/callsAndMessages.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flowNotifier = Provider.of<FlowNotifier>(context);
    final circlesNotifier = Provider.of<CirclesNotifier>(context);
    final notificationsNotifier = Provider.of<NotificationsNotifier>(context);
    final paymentsNotifier = Provider.of<PaymentsNotifier>(context);
    final payoutsNotifier = Provider.of<PayoutsNotifier>(context);
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final User _user = authenticationNotifier.user;

    final recentActivitiesNotifier =
        Provider.of<RecentActivitiesNotifier>(context);
    final List<RecentActivity> _recentActivities =
        recentActivitiesNotifier.recentActivities;

    final User _person = ModalRoute.of(context).settings.arguments;
    final bool _isMe = _person?.email == _user?.email || _person == null;

    final i18nNotifier = Provider.of<I18nNotifier>(context);

    final CallsAndMessages callsAndMessages = CallsAndMessages();

    return SaffoldedProfile(
      isScaffolded: _person != null,
      child:  ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Column(
            //padding: EdgeInsets.all(0),
            children: <Widget>[
              RichHeader(title: null),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SectionTitle(
                  text: FlutterI18n.translate(context, "user_profile"),
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 8 * 2.0),
              if (!_isMe)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProfileCard(
                    name: _person?.username,
                    email: _person?.email,
                    phone: _person?.phone,
                    image: _person?.image,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProfileCard(
                    name: _user?.username?.toUpperCase() ?? '...',
                    email: _user?.email,
                    phone: _user?.phone,
                    image: _user?.image,
                  ),
                ),
              SizedBox(height: 8 * 2.0),
              if (_isMe) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionTitle(
                    text: FlutterI18n.translate(context, "recent_activity"),
                    isExpandable: true,
                    length: _recentActivities.length,
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/recent-activities'),
                  ),
                ),
                SizedBox(height: 8 * 2.0),
                StreamBuilder(
                    stream: UserFirestoreDatabase.getRecentPayment(userId: _user?.id),
                    builder: (context, AsyncSnapshot<List<Future<RecentActivity>>> circleSP) {

                      if(circleSP.hasData && circleSP.data.length>0)
                        return ListView.builder(
                          //scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(2.0),
                          primary: false,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: circleSP.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder(future: circleSP.data[index],
                                builder: (BuildContext context, AsyncSnapshot result) {
                                  RecentActivity recentActivity = result.data as RecentActivity;

                                  if(recentActivity!=null)
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: RichCard(
                                        title: recentActivity.title,
                                        subTitle: recentActivity.paymentDate
                                            .toString()
                                            .split(' ')
                                            .first,
                                        isLightTitle: true,
                                        trailing: recentActivity.amount.toString(),
                                      ),
                                    );
                                  else if (recentActivity==null){
                                    return Container();
                                  }
                                  else return Container(
                                    height: 50,
                                    width: 50,
                                    child: StyledLoader(),
                                  );
                                });
                          },
                        );
                      else
                        return  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                            /*child: Text(
                              FlutterI18n.translate(context,
                                  "your_recent_activities_will_be_listed_here"),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),*/
                          ),
                        );
                    }),
                StreamBuilder(
                    stream: UserFirestoreDatabase.getRecentPayout(userId: _user?.id),
                    builder: (context, AsyncSnapshot<List<Future<RecentActivity>>> circleSP) {

                      if(circleSP.hasData && circleSP.data.length>0)
                        return ListView.builder(
                          //scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(2.0),
                          primary: false,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: circleSP.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder(future: circleSP.data[index],
                                builder: (BuildContext context, AsyncSnapshot result) {
                                  RecentActivity recentActivity = result.data as RecentActivity;

                                  if(recentActivity!=null)
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: RichCard(
                                        title: recentActivity.title,
                                        subTitle: recentActivity.paymentDate
                                            .toString()
                                            .split(' ')
                                            .first,
                                        isLightTitle: true,
                                        trailing: recentActivity.amount.toString(),
                                      ),
                                    );
                                  else if (recentActivity==null){
                                    return Container();
                                  }
                                  else return Container(
                                      height: 50,
                                      width: 50,
                                      child: StyledLoader(),
                                    );
                                });
                          },
                        );
                      else
                        return  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                            /*child: Text(
                              FlutterI18n.translate(context,
                                  "your_recent_activities_will_be_listed_here"),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),*/
                          ),
                        );
                    }),
               /* if (_recentActivities.length > 0)
                  for (final recentActivity in _recentActivities.sublist(
                      0, min(_recentActivities.length, 5))) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RichCard(
                        title: recentActivity.title,
                        subTitle: recentActivity.paymentDate
                            .toString()
                            .split(' ')
                            .first,
                        isLightTitle: true,
                        trailing: recentActivity.amount.toString(),
                      ),
                    ),
                    SizedBox(height: 12),
                  ]
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                        FlutterI18n.translate(context,
                            "your_recent_activities_will_be_listed_here"),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),*/
              ],
              SizedBox(height: 8 * 4.0),
              if (!_isMe)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionTitle(text: 'Contact'),
                ),
              SizedBox(height: 8 * 2.0),
              if (!_isMe)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      RoundedButton(
                        label: FlutterI18n.translate(context, "call"),
                        labelSize: 11,
                        icon: GolakIcons.phone,
                        iconSize: 15,
                        isSmall: true,
                        isShrink: true,
                        onPressed: () {
                          callsAndMessages.call(_person.phone);
                        },
                      ),
                      RoundedButton(
                        label: FlutterI18n.translate(context, "send_message"),
                        labelSize: 11,
                        icon: GolakIcons.message,
                        iconSize: 15,
                        isSmall: true,
                        isShrink: true,
                        onPressed: () {
                          callsAndMessages.sendSms(_person.phone);
                        },
                      ),
                      RoundedButton(
                        label: FlutterI18n.translate(context, "whatsapp"),
                        labelSize: 11,
                        icon: GolakIcons.whatsapp,
                        iconSize: 15,
                        isSmall: true,
                        isShrink: true,
                        onPressed: () {
                          callsAndMessages.whatsapp(_person.phone, () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StyledAlertDialog(
                                    label: FlutterI18n.translate(
                                      context,
                                      "ok",
                                    ),
                                    title: FlutterI18n.translate(
                                      context,
                                      "cannot_open_whatsapp",
                                    ),
                                    content: FlutterI18n.translate(
                                      context,
                                      "please_make_sure_you_already_have_whatsapp_installed",
                                    ),
                                    cancel: false,
                                    callback: () async {
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          });
                        },
                      ),
                      RoundedButton(
                        label: FlutterI18n.translate(context, "email"),
                        labelSize: 11,
                        icon: GolakIcons.email,
                        iconSize: 15,
                        isSmall: true,
                        isShrink: true,
                        onPressed: () {
                          callsAndMessages.sendEmail([_person.email], '', '');
                        },
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: RoundedButton(
                    label: FlutterI18n.translate(context, "log_out"),
                    isSmall: true,
                    isShrink: true,
                    // isPassive: true,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext cxt) {
                          return StyledAlertDialog(
                            label: FlutterI18n.translate(context, "log_out"),
                            title: FlutterI18n.translate(context, "log_out"),
                            content: FlutterI18n.translate(
                              context,
                              "are you sure you want to logout?",
                            ),
                            callback: () async {
                              Navigator.pop(cxt);
                              await authenticationNotifier.clean(
                                  playerId: notificationsNotifier.playerId);
                              await circlesNotifier.clean();
                              await notificationsNotifier.clean();
                              await paymentsNotifier.clean();
                              await payoutsNotifier.clean();
                              await recentActivitiesNotifier.clean();
                              flowNotifier.currentPage = 0;
                              Timer(Duration(milliseconds: 200), () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/welcome',
                                  (_) => false,
                                );
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 8 * 9.0),
            ],
          ),
          if (Provider.of<AuthenticationNotifier>(context).loading)
            StyledLoader(),
        ],
      ),
    );
  }
}

class SaffoldedProfile extends StatelessWidget {
  SaffoldedProfile({this.child, this.isScaffolded});
  final bool isScaffolded;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return isScaffolded
        ? Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: NotchedFAB(),
            bottomNavigationBar: NotchedBottomAppBar(),
            body: child,
          )
        : child;
  }
}
