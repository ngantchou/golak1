import 'package:flutter/material.dart';

/*
GolakIcon(
  GolakIcons.statistics,
  size: iconSize,
),
*/
class GolakIcon extends StatelessWidget {
  GolakIcon(
    this.icon, {
    Key key,
    this.size = 24,
    this.color,
  }) : super(key: key);
  final String icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      icon,
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class GolakIcons {
  static final String add = "icons/add@3x.png";
  static final String back = "icons/back@3x.png";
  static final String checkCircleThin = "icons/check-circle-thin@3x.png";
  static final String checkCircle = "icons/check-circle@3x.png";
  static final String circleAdd = "icons/circle-add@3x.png";
  static final String circle = "icons/circle@3x.png";
  static final String delete = "icons/delete@3x.png";
  static final String download = "icons/download@3x.png";
  static final String email = "icons/email@3x.png";
  static final String home = "icons/home@3x.png";
  static final String ledger = "icons/ledger@3x.png";
  static final String message = "icons/message@3x.png";
  static final String personOutline = "icons/person-outline@3x.png";
  static final String person = "icons/person@3x.png";
  static final String phone = "icons/phone@3x.png";
  static final String reminders = "icons/reminders@3x.png";
  static final String share = "icons/share@3x.png";
  static final String statistics = "icons/statistics@3x.png";
  static final String whatsapp = "icons/whatsapp@3x.png";
  static final String lock = "icons/lock@3x.png";
  static final String backArrow = "icons/back-arrow@3x.png";
  static final String calendar = "icons/calendar@3x.png";
  static final String contribution = "icons/contribution@3x.png";
  static final String country = "icons/country@3x.png";
  static final String people = "icons/people@3x.png";
  static final String search = "icons/search@3x.png";
  static final String slots = "icons/slots@3x.png";
  static final String totalAmount = "icons/total-amount@3x.png";
}
