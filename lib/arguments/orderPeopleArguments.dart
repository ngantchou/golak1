import 'package:golak/models/circle.dart';

class OrderPeopleArguments {
  final List<String> emails;
  final List<String> names;
  final List<String> phones;
  final bool randomSlots;
  final Circle circle;
  OrderPeopleArguments({
    this.names,
    this.emails,
    this.phones,
    this.randomSlots,
    this.circle,
  });
}
