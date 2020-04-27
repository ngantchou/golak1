import 'package:flutter/foundation.dart';
import 'package:golak/firestore_database/circle_fs_db.dart';
import 'package:golak/firestore_database/round_fs_db.dart';
import 'package:golak/models/ledger.dart';
import 'package:golak/network/ledger.dart' as ledgerNetwork;

class LedgerNotifier with ChangeNotifier {
  Future<List<Future<Ledger>>> getLedger(
      {@required accessToken, @required circleId}) async {
    // loading = true;
    List<Future<Ledger>> $response;
    try {
      List<String> roundIds = await RoundFirestoreDatabase.getRoundForCircle(circleId: circleId).first;
      $response = await CircleFirestoreDatabase.getLedger(
        circleId: circleId,
        roundIds: roundIds
      ).first;
    } catch (e) {}
    if ($response != null) {
      return $response;
    } else {
      // loading = false;
      return null;
    }
  }
}
