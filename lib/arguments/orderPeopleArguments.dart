import 'package:golak/models/circle.dart';
import 'package:golak/models/user.dart';

class OrderPeopleArguments {
  final List<String> emails;
  final List<String> names;
  final List<String> phones;
  final List<User> userspaiy;
  final bool randomSlots;
  final List<bool> isPay;
  final Circle circle;
  OrderPeopleArguments({
    this.names,
    this.emails,
    this.phones,
    this.randomSlots,
    this.circle,
    this.isPay,
    this.userspaiy
  });
}
