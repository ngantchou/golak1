import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/circleCard.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class CirclesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final circlesNotifier = Provider.of<CirclesNotifier>(context);
    final List<Circle> _circles = circlesNotifier.circles;
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotchedFAB(),
      bottomNavigationBar: NotchedBottomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          RichHeader(title: null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SectionTitle(
              text: FlutterI18n.translate(context, "manage_circles"),
              fontSize: 25,
            ),
          ),
          SizedBox(height: 8 * 2.0),
          if (_circles.length > 0)
            for (final circle in _circles)
              CircleCard(
                circle: circle,
              )
          else
            Container(
              height: 190,
              width: 150,
              margin: EdgeInsets.only(
                right: 16,
                top: 8,
                bottom: 8,
                left: 16,
              ),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, 4),
                    color: Colors.black.withOpacity(.1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'All circles \nwill be shown here',
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first circle',
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  NotchedFAB(
                    heroTag: 'circles',
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
