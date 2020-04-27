import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/richCard.dart';
import 'package:golak/elements/styledLoader.dart';
import 'package:golak/firestore_database/payments_fs_db.dart';
import 'package:golak/models/payout.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/payoutsNotifier.dart';
import 'package:provider/provider.dart';

class UpcomingPayoutsCards extends StatelessWidget {
  const UpcomingPayoutsCards({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final payoutsNotifier = Provider.of<PayoutsNotifier>(context);
    final List<Payout> _payouts = payoutsNotifier.payouts;
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final String _accessToken = authenticationNotifier.accessToken;
    return Container(
        height: 180 + 24.0,
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StreamBuilder(
            stream: PaymentFirestoreDatabase.getUpcomingPayouts(circleId: null,userId: _accessToken),
            builder: (context, AsyncSnapshot<List<Future<Payout>>> circleSP) {
              if(circleSP.connectionState== ConnectionState.waiting)
                return Container(
                  height: 50,
                  width: 50,
                  child: StyledLoader(),
                );
              if(circleSP.hasData && circleSP.data.length>0)
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(2.0),
                  primary: false,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: circleSP.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(future: circleSP.data[index],
                        builder: (BuildContext context, AsyncSnapshot result) {
                          Payout payout = result.data as Payout;

                          if(payout!=null)
                            return Container(
                            height: 180,
                            width: 150,
                            margin: EdgeInsets.only(right: 16, top: 8, bottom: 16),
                            padding: EdgeInsets.all(16),
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 8 * 6.0,
                                  child: Text(
                                    payout.circleName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  height: 34,
                                  width: 66,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF76D0B7),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    '\$${payout.amount.toString()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  FlutterI18n.translate(context, "recieve on"),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  payout.upcomingDate.toString().split(' ').first,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF484855),
                                  ),
                                ),
                              ],
                            ),
                          );

                          else  return Container();
                        });
                  },
                );
              else
                return Padding(
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
                      FlutterI18n.translate(context, "you_dont_have_payouts_yet"),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
            }),
       /* if (_payouts.length > 0)
          for (final payment
              in _payouts.sublist(0, min(_payouts.length, 5))) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: RichCard(
                title: payment.circleName,
                subTitle: payment.upcomingDate.toString().split(' ').first,
                trailing: payment.amount.toString(),
              ),
            ),
            SizedBox(height: 12),
          ]
        else
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
              FlutterI18n.translate(context, "you_dont_have_payouts_yet"),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),*/
      ],
    ));
  }
}
