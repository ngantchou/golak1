import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class StyledAlertDialog extends StatelessWidget {
  const StyledAlertDialog({
    Key key,
    @required this.callback,
    @required this.title,
    @required this.label,
    @required this.content,
    this.cancel = true,
  }) : super(key: key);

  final callback;
  final String label;
  final String title;
  final String content;
  final bool cancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text('$title'),
      content: Text('$content'),
      actions: <Widget>[
        if (cancel)
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              FlutterI18n.translate(context, "cancel"),
              style: TextStyle(
                color: Color(0xFF76D0B7),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: Color(0xFF76D0B7),
            onPressed: callback,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
