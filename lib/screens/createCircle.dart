import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/arguments/invitePeopleArguments.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/header.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/elements/roundedTextFormField.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class CreateCirclePage extends StatefulWidget {
  @override
  _CreateCirclePageState createState() => _CreateCirclePageState();
}

class _CreateCirclePageState extends State<CreateCirclePage> {
  final TextEditingController _minimumContributionController =
      TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  DateTime _startDate = DateTime.now();
  String _contributionType = 'Monthly';
  bool _randomSlots = false;
  bool _participate = false;
  String _numberOfPeople = '3';

  void _pickStartDate(DateTime date) {
    setState(() {
      _startDate = date;
    });
  }

  void _pickContributionType(String contributionType) {
    setState(() {
      _contributionType = contributionType;
    });
  }

  void _pickSlots(String randomSlots) {
    setState(() {
      _randomSlots = randomSlots == 'randomly';
    });
  }

  void _pickParticipate(String participate) {
    setState(() {
      _participate = participate == 'in';
    });
  }

  void _pickNumberOfPeople(String numberOfPeople) {
    setState(() {
      _numberOfPeople = numberOfPeople;
    });
  }

  bool validated = false;

  String _nameValidator(_) {
    if (_nameController.text.length < 1) {
      return 'Circle name is required';
    }
    return null;
  }

  String _minimumContributionValidator(_) {
    if (_minimumContributionController.text.length < 1) {
      return 'Minimum contribution is required';
    } else {
      try {
        double.parse(_minimumContributionController.text);
      } catch (error) {
        return 'Enter a valid contribution value';
      }
    }
    return null;
  }

  String _totalAmountValidator(_) {
    if (_totalAmountController.text.length < 1) {
      return 'Total amount is required';
    } else {
      try {
        double minContrigution = double.parse(
          _minimumContributionController.text,
        );
        double totalAmount = double.parse(_totalAmountController.text);
        if (totalAmount < minContrigution)
          return 'Total amount should be greater then minimum contribution';
      } catch (error) {
        return 'Enter a valid amount';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final circlesNotifier = Provider.of<CirclesNotifier>(context);
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Header(
            title: FlutterI18n.translate(context, "create_new_circle"),
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                RoundedTextFormField(
                  controller: _nameController,
                  label: FlutterI18n.translate(context, "circle_name"),
                  icon: GolakIcons.share,
                  validator: _nameValidator,
                  validated: validated,
                ),
                SizedBox(height: 8),
                RoundedTextFormField(
                  label: FlutterI18n.translate(context, "minimum_contribution"),
                  controller: _minimumContributionController,
                  icon: GolakIcons.contribution,
                  keyboardType: TextInputType.numberWithOptions(
                    signed: true,
                  ),
                  validated: validated,
                  validator: _minimumContributionValidator,
                ),
                SizedBox(height: 8),
                StyledRichDropdown(
                  callback: _pickContributionType,
                  label: FlutterI18n.translate(context, "contribution_type"),
                  icon: GolakIcons.contribution,
                  options: <Option>[
                    Option(
                      value: 'daily',
                      text: FlutterI18n.translate(context, "daily"),
                    ),
                    Option(
                      value: 'weekly',
                      text: FlutterI18n.translate(context, "weekly"),
                    ),
                    Option(
                      value: 'bi-weekly',
                      text: FlutterI18n.translate(context, "bi_weekly"),
                    ),
                    Option(
                      value: 'monthly',
                      text: FlutterI18n.translate(context, "monthly"),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                RoundedTextFormField(
                  label: FlutterI18n.translate(context, "total_amount"),
                  controller: _totalAmountController,
                  icon: GolakIcons.share,
                  keyboardType: TextInputType.numberWithOptions(
                    signed: true,
                  ),
                  validated: validated,
                  validator: _totalAmountValidator,
                ),
                SizedBox(height: 8),
                StyledRichDropdown(
                  callback: _pickNumberOfPeople,
                  label: FlutterI18n.translate(context, "number_of_people"),
                  icon: GolakIcons.people,
                  options: <Option>[

                    Option(
                      value: '3',
                      text: '3',
                    ),
                    Option(
                      value: '4',
                      text: '4',
                    ),
                    Option(
                      value: '5',
                      text: '5',
                    ),
                    Option(
                      value: '6',
                      text: '6',
                    ),
                    Option(
                      value: '7',
                      text: '7',
                    ),
                    Option(
                      value: '8',
                      text: '8',
                    ),
                    Option(
                      value: '9',
                      text: '9',
                    ),
                    Option(
                      value: '10',
                      text: '10',
                    ),
                    Option(
                      value: '11',
                      text: '11',
                    ),
                    Option(
                      value: '12',
                      text: '12',
                    ),
                  ],
                ),
                SizedBox(height: 8),
                RichDatePicker(
                  label: FlutterI18n.translate(context, "start_date"),
                  icon: GolakIcons.calendar,
                  callback: _pickStartDate,
                ),
                SizedBox(height: 8),
                StyledRichDropdown(
                  label: FlutterI18n.translate(context, "slots"),
                  icon: GolakIcons.slots,
                  callback: _pickSlots,
                  options: <Option>[
                    Option(
                      value: 'manually',
                      text: FlutterI18n.translate(context, "manually"),
                    ),
                    Option(
                      value: 'randomly',
                      text: FlutterI18n.translate(context, "randomly"),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                StyledRichDropdown(
                  icon: GolakIcons.circle,
                  label: FlutterI18n.translate(context, "participate"),
                  callback: _pickParticipate,
                  options: <Option>[
                    Option(
                      value: 'out',
                      text: FlutterI18n.translate(
                          context, "I_am_not_willing_to_participate"),
                    ),
                    Option(
                      value: 'in',
                      text: FlutterI18n.translate(
                          context, "I_am_participante_and_admin"),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                RoundedButton(
                  label: FlutterI18n.translate(context, "complete"),
                  labelSize: 15,
                  onPressed: () {
                    if (_nameValidator(null) == null &&
                        _minimumContributionValidator(null) == null &&
                        _totalAmountValidator(null) == null) {
                      circlesNotifier.newCircle = Circle()
                        ..name = _nameController.text
                        ..minContrib =
                            double.parse(_minimumContributionController.text)
                        ..contribType = _contributionType
                        ..totalAmount =
                            double.parse(_totalAmountController.text)
                        ..involvedUsers = List(int.parse(_numberOfPeople))
                        ..startDate = _startDate
                        ..currentRound = Round(
                            endDate: DateTime(
                              _startDate.year,
                              _startDate.month,
                              _startDate.day,
                            ),
                            startDate: _startDate,
                            recipientId: null,
                            paymentsDoneSum: 0,
                            paymentsDoneDetails: []);

                      Navigator.of(context).pushNamed(
                        '/invite-people',
                        arguments: InvitePeopleArguments(
                          numberOfPeople: int.parse(
                            _numberOfPeople,
                          ),
                          randomSlots: _randomSlots,
                          participate: _participate,
                        ),
                      );
                    } else {
                      validated = true;
                      setState(() {});
                    }
                  },
                  isSmall: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 8 * 9.0),
        ],
      ),
    );
  }
}

class RichDatePicker extends StatefulWidget {
  RichDatePicker({
    this.options = const [],
    @required this.label,
    @required this.icon,
    @required this.callback,
  });
  final List<Option> options;
  final String label;
  final String icon;
  final callback;

  @override
  _RichDatePickerState createState() => _RichDatePickerState();
}

class _RichDatePickerState extends State<RichDatePicker> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime max = DateTime(now.year + 1, now.month, now.day);
    final DateTime picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.white,
          child: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                Container(
                  height: 200 - 46.0 - 16,
                  child: DefaultTextStyle.merge(
                    style: TextStyle(fontSize: 16),
                    child: CupertinoDatePicker(
                      onDateTimeChanged: (DateTime date) {
                        selectedDate = date;
                        setState(() {});
                      },
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      minimumDate: now,
                      maximumDate: max,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: RoundedButton(
                    label: 'Confirm',
                    labelSize: 15,
                    onPressed: () {
                      Navigator.of(context).pop(selectedDate);
                    },
                    isSmall: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.callback(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return Container(
      height: 53 + 14.0,
      child: Stack(
        alignment: i18nNotifier.rtl ? Alignment.topRight : Alignment.topLeft,
        children: <Widget>[
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Container(
              height: 52,
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  alignment: i18nNotifier.rtl
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    '${selectedDate.toLocal().toString().split(' ').first}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.shade600),
                borderRadius: BorderRadius.circular(52),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: i18nNotifier.rtl ? null : 32,
            right: !i18nNotifier.rtl ? null : 32,
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GolakIcon(
                    widget.icon,
                    color: Color(0xFF686868),
                    size: 21,
                  ),
                  SizedBox(width: 2),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: Color(0xFF686868),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StyledRichDropdown extends StatelessWidget {
  StyledRichDropdown({
    this.options = const [],
    @required this.label,
    @required this.icon,
    @required this.callback,
  });
  final List<Option> options;
  final String label;
  final String icon;
  final callback;

  @override
  Widget build(BuildContext context) {
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return Container(
      height: 53 + 14.0,
      child: Stack(
        alignment: i18nNotifier.rtl ? Alignment.topRight : Alignment.topLeft,
        children: <Widget>[
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Container(
              height: 52,
              child: RichDropdown(
                options: options,
                callback: callback,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey.shade600,
                ),
                borderRadius: BorderRadius.circular(52),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: i18nNotifier.rtl ? null : 32,
            right: !i18nNotifier.rtl ? null : 32,
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GolakIcon(
                    icon,
                    color: Color(0xFF686868),
                    size: 21,
                  ),
                  SizedBox(width: 2),
                  Text(
                    label,
                    style: TextStyle(
                      color: Color(0xFF686868),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Option {
  dynamic value;
  final String text;
  Option({this.value, @required this.text});
}

class RichDropdown extends StatefulWidget {
  RichDropdown({
    this.options = const [],
    this.callback,
  });
  final List<Option> options;
  final callback;

  @override
  _RichDropdownState createState() => _RichDropdownState();
}

class _RichDropdownState extends State<RichDropdown> {
  Option selectedOption;
  @override
  void initState() {
    super.initState();
    if (widget.options != null && widget.options.length > 0)
      selectedOption = widget.options.first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 16),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: Container(),
        items: [
          for (final option in widget.options)
            DropdownMenuItem(
              value: option.value,
              child: Text(
                option.text,
              ),
            ),
        ],
        onChanged: (value) {
          setState(() {
            selectedOption = widget.options.firstWhere(
              (Option option) => option.value == value,
            );
            widget.callback(selectedOption?.value);
          });
        },
        value: selectedOption?.value,
      ),
    );
  }
}
