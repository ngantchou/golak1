import 'package:golak/models/circle.dart';

class InvitePeopleArguments {
  final int numberOfPeople;
  final Circle circle;
  final bool randomSlots;
  final bool participate;
  InvitePeopleArguments({
    this.numberOfPeople,
    this.circle,
    this.randomSlots,
    this.participate,
  });
}
