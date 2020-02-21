import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/richLedger.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/store/notifiers/ledgerNotifier.dart';
import 'package:golak/utils/pdf.dart';
import 'package:provider/provider.dart';

class LedgerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    final Circle circle = ModalRoute.of(context).settings.arguments;
    final ledgerNotifier = Provider.of<LedgerNotifier>(context);
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final accessToken = authenticationNotifier.accessToken;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          RichHeader(
            title:
                '${circle.name} \n${FlutterI18n.translate(context, "ledger")}',
          ),
          SizedBox(height: 8 * 2.0),
          FutureBuilder(
            future: ledgerNotifier.getLedger(
              circleId: circle.id,
              accessToken: accessToken,
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return RichLedger(snapshot.data);
              } else
                return RichLedger([]);
            },
          ),
          SizedBox(height: 32),
          Center(
            child: RoundedButton(
              label: FlutterI18n.translate(context, "download"),
              labelSize: 15,
              icon: GolakIcons.download,
              onPressed: () => exportAsPDF(),
              isSmall: true,
            ),
          ),
          SizedBox(height: 8 * 9.0),
        ],
      ),
    );
  }
}
