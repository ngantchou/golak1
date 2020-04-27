import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/paymentsNotifier.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/models/circle.dart';
import 'package:provider/provider.dart';

class Payment extends StatefulWidget {
  Payment({
    Key key,
    @required this.paymentId,
    @required this.userId,
    @required this.name,
    @required this.image,
    @required this.paid,
    @required this.roundId,
    @required this.amount,
    @required this.circleName,
    @required this.recipiendName,
    @required this.nextUserRoundId,
    @required this.upcomingDate,
    @required this.circleId,
    @required this.createdBy,
  });
  final String circleId;
  final String createdBy;
  final String paymentId;
  final String userId;
  final String name;
  final String image;
  final bool paid;

  final String roundId;
  final double amount;
  final String circleName;
  final String nextUserRoundId;
  final String recipiendName;
  final DateTime upcomingDate;

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool _paid = false;
  @override
  void initState() {
    super.initState();
    _paid = widget.paid;
  }

  @override
  Widget build(BuildContext context) {
    final paymentsNotifier = Provider.of<PaymentsNotifier>(context);
    final circlesNotifier = Provider.of<CirclesNotifier>(context);
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final _accessToken = authenticationNotifier.accessToken;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
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
      child: Row(
        children: <Widget>[
          SizedBox(width: 16),
          Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Color(0xFF76D0B7),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'images/person.jpg',
                  ),
                ),
              ),
              child: ClipOval(
                child: widget.image != null && widget.image != ''
                    ? Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              '${widget.name}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF75CFB6),
              ),
            ),
          ),
          Spacer(),
          Container(
            width: 111.5,
            height: 32.1,
            child: FlatButton(
              color: _paid ? Color(0xFF76D0B7) : Color(0xFFB8B8B8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: () async {
                if (widget.roundId == null && widget.createdBy!= _accessToken ) return;
                _paid = !_paid;
                setState(() {});
                if (_paid) {
                  circlesNotifier.circles =
                      circlesNotifier.circles.map((Circle circle) {
                    /*
                      circle.currentRound.paymentsDoneDetails.where((payment) {
                        return payment['from_user'] == involvedUser['_id'];
                      }).first['_id']
                      */
                    if (circle.id == widget.circleId) {
                      circle.currentRound.paymentsDoneDetails.add({
                        'from_user': widget.userId,
                      });
                      circle.currentRound.paymentsDoneSum += circle.minContrib;
                    }
                    return circle;
                  }).toList();

                  await paymentsNotifier.createPayment(
                    userId: widget.userId,
                    createdBy: authenticationNotifier.user.username,
                    userPayName: widget.name,
                    accessToken: _accessToken,
                    roundId: widget.roundId,
                    amount: widget.amount,
                    circleName: widget.circleName,
                    recipiendName: widget.recipiendName,
                    upcomingDate: widget.upcomingDate,
                    nextUserRoundId: widget.nextUserRoundId,
                  );
                } else {
                  circlesNotifier.circles =
                      circlesNotifier.circles.map((Circle circle) {
                    if (circle.id == widget.circleId) {
                      circle.currentRound.paymentsDoneDetails
                          .removeWhere((payment) {
                        return payment['from_user'] == widget.userId;
                      });
                      circle.currentRound.paymentsDoneSum -= circle.minContrib;
                    }
                    return circle;
                  }).toList();

                  await paymentsNotifier.deletePayment(
                    paymentId: widget.paymentId,
                    accessToken: _accessToken,
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GolakIcon(
                    _paid ? GolakIcons.checkCircleThin : GolakIcons.delete,
                    size: 12,
                  ),
                  SizedBox(width: 8),
                  Text(
                    FlutterI18n.translate(context, _paid ? "paid" : 'not_paid'),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
