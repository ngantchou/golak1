import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/arguments/invitePeopleArguments.dart';
import 'package:golak/arguments/orderPeopleArguments.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/header.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/elements/roundedTextFormField.dart';
import 'package:golak/models/user.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/utils/callsAndMessages.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';

class InvitePeoplePage extends StatefulWidget {
  @override
  _InvitePeoplePageState createState() => _InvitePeoplePageState();
}

class _InvitePeoplePageState extends State<InvitePeoplePage> {
  List<TextEditingController> _nameControllers = [];
  List<TextEditingController> _emailControllers = [];
  List<TextEditingController> _phoneControllers = [];


  @override
  void initState() {
    super.initState();

    for (final _ in List(12)) {
      _nameControllers.add(
        TextEditingController(),
      );
      _emailControllers.add(
        TextEditingController(),
      );
      _phoneControllers.add(
        TextEditingController(),
      );
    }
    setState(() {});
  }

  bool validated = false;

  String _nameValidator(nameController) {
    if (nameController.text.length < 1) {
      return 'Name is required';
    }
    return null;
  }

  String _emailValidator(emailController) {
    if (emailController.text.length < 1) {
      return 'Email is required';
    } else if (!validator.email(emailController.text)) {
      return 'Enter a valide email address';
    }
    return null;
  }

  String _phoneValidator(phoneController) {
    if (phoneController.text.length < 1) {
      return 'Phone is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final InvitePeopleArguments arguments =
        ModalRoute.of(context).settings.arguments;

    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final User _user = authenticationNotifier.user;

    final int _numberOfPeople =
        arguments.numberOfPeople - (arguments.participate ? 1 : 0);

    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Header(
            title: FlutterI18n.translate(context, "invite_people"),
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                for (final index in List(_numberOfPeople).asMap().keys)
                  Column(
                    children: <Widget>[
                      RoundedTextFormField(
                        label: FlutterI18n.translate(context, "name"),
                        controller: _nameControllers[index],
                        icon: GolakIcons.person,
                        validated: validated,
                        validator: _nameValidator,
                      ),
                      SizedBox(height: 8),
                      RoundedTextFormField(
                        label: FlutterI18n.translate(context, "email"),
                        controller: _emailControllers[index],
                        icon: GolakIcons.email,
                        validated: validated,
                        validator: _emailValidator,
                      ),
                      SizedBox(height: 8),
                      RoundedTextFormField(
                        label: FlutterI18n.translate(context, "phone_number"),
                        controller: _phoneControllers[index],
                        icon: GolakIcons.phone,
                        validated: validated,
                        validator: _phoneValidator,
                      ),
                      SizedBox(height: 32),
                      if (index + 1 != arguments.numberOfPeople) ...[
                        Container(
                          color: Color(0xFF76D0B7),
                          height: 1.5,
                          margin: EdgeInsets.symmetric(horizontal: 48),
                        ),
                        SizedBox(height: 24)
                      ],
                    ],
                  ),
                if (arguments.participate) ...[
                  IgnorePointer(
                    ignoring: true,
                    child: RoundedTextFormField(
                        label: FlutterI18n.translate(context, "name"),
                        initialValue: _user.username,
                        icon: GolakIcons.person,
                        accentColor: Color(0xFF76D0B7)),
                  ),
                  SizedBox(height: 8),
                  IgnorePointer(
                    ignoring: true,
                    child: RoundedTextFormField(
                        label: FlutterI18n.translate(context, "email"),
                        initialValue: _user.email,
                        icon: GolakIcons.email,
                        accentColor: Color(0xFF76D0B7)),
                  ),
                  SizedBox(height: 8),
                  IgnorePointer(
                    ignoring: true,
                    child: RoundedTextFormField(
                        label: FlutterI18n.translate(context, "phone_number"),
                        initialValue: _user.phone,
                        icon: GolakIcons.phone,
                        accentColor: Color(0xFF76D0B7)),
                  ),
                  SizedBox(height: 24),
                ],
                SizedBox(
                  height: 8 * 4.0,
                ),
                RoundedButton(
                  label: FlutterI18n.translate(context, "complete"),
                  labelSize: 15,
                  onPressed: () {
                    print('validating');

                    final bool _namesAreValide = _nameControllers
                        .sublist(0, _numberOfPeople)
                        .map((TextEditingController _c) =>
                            _nameValidator(_c) == null)
                        .toList()
                        .reduce((b1, b2) => b1 && b2);

                    final bool _emailsAreValide = _emailControllers
                        .sublist(0, _numberOfPeople)
                        .map((TextEditingController _c) =>
                            _emailValidator(_c) == null)
                        .toList()
                        .reduce((b1, b2) => b1 && b2);

                    final bool _phonesAreValide = _phoneControllers
                        .sublist(0, _numberOfPeople)
                        .map((TextEditingController _c) =>
                            _phoneValidator(_c) == null)
                        .toList()
                        .reduce((b1, b2) => b1 && b2);

                    print('_namesAreValide: $_namesAreValide');
                    if (_namesAreValide &&
                        _phonesAreValide &&
                        _emailsAreValide) {
                      print('valide!');
                      final List<String> _names = _nameControllers
                          .sublist(0, _numberOfPeople)
                          .map((TextEditingController _c) => _c.text)
                          .toList();
                      final List<String> _emails = _emailControllers
                          .sublist(0, _numberOfPeople)
                          .map((TextEditingController _c) => _c.text)
                          .toList();
                      final List<String> _phones = _phoneControllers
                          .sublist(0, _numberOfPeople)
                          .map((TextEditingController _c) => _c.text)
                          .toList();
                      Navigator.of(context).pushNamed(
                        '/order-people',
                        arguments: OrderPeopleArguments(
                          names: arguments.participate
                              ? [..._names, _user.username]
                              : _names,
                          emails: arguments.participate
                              ? [..._emails, _user.email]
                              : _emails,
                          phones: arguments.participate
                              ? [..._phones, _user.phone]
                              : _phones,
                          randomSlots: arguments.randomSlots,
                          circle :arguments.circle,
                        ),
                      );
                      final CallsAndMessages callsAndMessages =
                          CallsAndMessages();

                      callsAndMessages.sendEmail(
                          _emailControllers
                              .sublist(0, arguments.numberOfPeople)
                              .map((TextEditingController _c) => _c.text)
                              .toList(),
                          'Invitation%20to%20Golak%20Circle',
                          'Hello%20there,%20You%20are%20invited%20to%20a%20new%20Golak%20Circle.%20From%20Golak');
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
