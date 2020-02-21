import 'package:flutter/material.dart';
import 'package:golak/elements/golakIcons.dart';

/*
RoundedButton(
  label: 'Circle Dashboard',
  labelSize: 15,
  icon: GolakIcons.statistics,
  iconSize: 22,
  onPressed: () {},
)
*/
class RoundedButton extends StatelessWidget {
  RoundedButton({
    Key key,
    this.label,
    this.labelSize = 15,
    this.labelColor = Colors.white,
    this.icon,
    this.iconSize = 22,
    this.iconColor = Colors.white,
    this.onPressed,
    this.isSmall = false,
    this.isShrink = false,
    this.isPassive = false,
  }) : super(key: key);
  final String label;
  final double labelSize;
  final Color labelColor;
  final String icon;
  final double iconSize;
  final Color iconColor;
  final onPressed;
  final bool isSmall;
  final bool isShrink;
  final bool isPassive;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: isShrink ? 152.71 : 264,
      // width: 264,
      height: isSmall ? 46 : 56,
      child: FlatButton(
        color: !isPassive ? Color(0xFF76D0B7) : Color(0xFFAAAAAA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) ...[
              GolakIcon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
              if (label != null) SizedBox(width: 8),
            ],
            if (label != null)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isShrink ? 95 : 152,
                ),
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: labelSize,
                    color: labelColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
