import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/richCard.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/firestore_database/payments_fs_db.dart';
import 'package:golak/models/payment.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/store/notifiers/paymentsNotifier.dart';
import 'package:provider/provider.dart';

class UpcomingPayments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentsNotifier = Provider.of<PaymentsNotifier>(context);
    final List<Payment> _payments = paymentsNotifier.payments;
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final String _accessToken = authenticationNotifier.accessToken;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          RichHeader(title: null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SectionTitle(
                text: FlutterI18n.translate(context, "upcoming_payments"),
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
          StreamBuilder(
              stream: PaymentFirestoreDatabase.getUpcomingPayments(circleId: null,userId: _accessToken),
              builder: (context, AsyncSnapshot<List<Future<Payment>>> circleSP) {

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
                            Payment payout = result.data as Payment;

                            if(payout!=null)
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: RichCard(
                                  title: payout.circleName,
                                  subTitle: DateTime.parse(payout.upcomingDate.toString().split(' ').first).toString(),
                                  trailing: payout.amount.toString(),
                                ),
                              );
                            else return Container();
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
          SizedBox(height: 8 * 2.0),
        ],
      ),
    );
  }
}
