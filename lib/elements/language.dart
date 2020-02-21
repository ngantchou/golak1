import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

/*
  Language()
*/
class Language extends StatefulWidget {
  Language({this.initialLang});
  final String initialLang;
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  bool isExpanded = false;
  String selectedLanguage;
  @override
  void initState() {
    super.initState();
    switch (widget.initialLang) {
      case 'en':
        selectedLanguage = 'English';
        break;
      case 'bn':
        selectedLanguage = 'Bengali';
        break;
      case 'ur':
        selectedLanguage = 'Urdu';
        break;
      case 'ar':
        selectedLanguage = 'Arabic';
        break;
      default:
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 45,
          child: FlatButton(
            onPressed: _toggleExpanded,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${FlutterI18n.translate(context, 'language')}:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFF6E7990),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  FlutterI18n.translate(context, selectedLanguage),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFF272A3F),
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  height: 16,
                  child: Icon(
                    Icons.chevron_right,
                    color: Color(0xFF6E7990),
                    size: 18,
                  ),
                )
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          Option(
            value: 'English',
            isSelected: selectedLanguage == 'English',
            onSelected: (lang) => _switchLanguage(context, lang),
          ),
          Option(
            value: 'Bengali',
            isSelected: selectedLanguage == 'Bengali',
            onSelected: (lang) => _switchLanguage(context, lang),
          ),
          Option(
            value: 'Urdu',
            isSelected: selectedLanguage == 'Urdu',
            onSelected: (lang) => _switchLanguage(context, lang),
          ),
          Option(
            value: 'Arabic',
            isSelected: selectedLanguage == 'Arabic',
            onSelected: (lang) => _switchLanguage(context, lang),
          ),
        ]
      ],
    );
  }

  _toggleExpanded() {
    isExpanded = !isExpanded;
    setState(() {});
  }

  _switchLanguage(context, lang) {
    isExpanded = false;
    selectedLanguage = lang;
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    switch (selectedLanguage) {
      case 'English':
        selectedLanguage = 'English';
        i18nNotifier.changeLanguage(context, "en");
        break;
      case 'Bengali':
        selectedLanguage = 'Bengali';
        i18nNotifier.changeLanguage(context, "bn");
        break;
      case 'Urdu':
        selectedLanguage = 'Urdu';
        i18nNotifier.changeLanguage(context, "ur");
        break;
      case 'Arabic':
        selectedLanguage = 'Arabic';
        i18nNotifier.changeLanguage(context, "ar");
        break;
      default:
    }

    setState(() {});
  }
}

class Option extends StatelessWidget {
  Option({
    Key key,
    @required this.value,
    this.isSelected = false,
    this.onSelected,
  }) : super(key: key);

  final String value;
  final bool isSelected;
  final onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: FlatButton(
        onPressed: () => onSelected(value),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isSelected) ...[
              Icon(
                Icons.check,
                size: 16,
              ),
              SizedBox(width: 4),
            ] else
              SizedBox(width: 16 + 4.0),
            Text(
              FlutterI18n.translate(context, value),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF272A3F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
