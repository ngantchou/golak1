import 'package:flutter/material.dart';

/*
RichCheckbox(
  label: 'Remember Me',
  onChanged: (_) {},
  value: true,
),
*/
class RichCheckbox extends StatelessWidget {
  RichCheckbox({
    Key key,
    @required this.label,
    @required this.onChanged,
    @required this.value,
  }) : super(key: key);
  final String label;
  final onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onChanged != null ? () => onChanged(value) : () {},
        child: Row(
          children: <Widget>[
            IgnorePointer(
              ignoring: true,
              child: Checkbox(
                activeColor: Color(0xFF76d0b7),
                onChanged: onChanged ?? (_) {},
                value: value,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF76D0B7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
