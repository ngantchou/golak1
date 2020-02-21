import 'package:flutter/foundation.dart';
import 'package:golak/models/ledger.dart';
import 'package:golak/network/ledger.dart' as ledgerNetwork;

class LedgerNotifier with ChangeNotifier {
  Future<List<Ledger>> getLedger(
      {@required accessToken, @required circleId}) async {
    // loading = true;
    var $response;
    try {
      $response = await ledgerNetwork.getLedger(
        accessToken: accessToken,
        circleId: circleId,
      );
    } catch (e) {}
    if ($response != null) {
      List<dynamic> jsonLedgerRows = $response['rows'];
      final List<Ledger> $ledger = jsonLedgerRows.map((ledger) {
        return Ledger.fromJson(ledger);
      }).toList();
      List<Ledger> _ledger = [];
      if ($ledger.length > 0) _ledger = $ledger.reversed.toList();
      // loading = false;
      return _ledger;
    } else {
      // loading = false;
      return null;
    }
  }
}
