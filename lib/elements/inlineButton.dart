import 'package:flutter/material.dart';

/*
InlineButton(
  leadingLabel: 'Don\'t have an account?',
  label: 'Sign up',
)
*/
class InlineButton extends StatelessWidget {
  InlineButton({
    Key key,
    @required this.leadingLabel,
    @required this.label,
    this.onPressed,
  }) : super(key: key);
  final String leadingLabel;
  final String label;
  final onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            leadingLabel,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          RawMaterialButton(
            onPressed: onPressed ?? () {},
            child: Text(
              label,
              style: TextStyle(
                color: Color(0xFF76D0B7),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
