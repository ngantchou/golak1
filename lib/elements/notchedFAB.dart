import 'package:flutter/material.dart';
import 'package:golak/elements/golakIcons.dart';

class NotchedFAB extends StatelessWidget {
  const NotchedFAB({
    Key key,
    this.heroTag,
  }) : super(key: key);
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    String currentRoute;
    Navigator.of(context).popUntil((route) {
      currentRoute = route.settings.name;
      return true;
    });
    return IgnorePointer(
      ignoring: currentRoute == '/create-circle',
      child: FloatingActionButton(
        heroTag: heroTag ?? 'notched-fab',
        onPressed: () => Navigator.of(context).pushNamed('/create-circle'),
        backgroundColor: Color(0xFF91D9C5),
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF76D0B7),
            borderRadius: BorderRadius.circular(50),
          ),
          child: GolakIcon(
            GolakIcons.add,
            color: Colors.white,
            size: 22.37,
          ),
        ),
      ),
    );
  }
}
