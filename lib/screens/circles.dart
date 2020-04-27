import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/circleCard.dart';
import 'package:golak/elements/notchedBottomAppBar.dart';
import 'package:golak/elements/notchedFAB.dart';
import 'package:golak/elements/richHeader.dart';
import 'package:golak/elements/sectionTitle.dart';
import 'package:golak/elements/styledLoader.dart';
import 'package:golak/firestore_database/circle_fs_db.dart';
import 'package:golak/models/circle.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/circlesNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class CirclesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final circlesNotifier = Provider.of<CirclesNotifier>(context);
    final List<Circle> _circles = circlesNotifier.circles;
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final String _accessToken = authenticationNotifier.accessToken;
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

          StreamBuilder(
              stream: CircleFirestoreDatabase.getCirclesManager(_accessToken),
              builder: (context, AsyncSnapshot<List<Future<Circle>>> circleSP) {

                if(circleSP.hasData && circleSP.data.length>0)
                  return ListView.builder(
                    //scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(2.0),
                    primary: false,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: circleSP.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder(future: circleSP.data[index],
                          builder: (BuildContext context, AsyncSnapshot result) {
                            Circle circle = result.data as Circle;

                            if(circle!=null)
                              return  CircleCard(
                                circle: circle,
                              );
                            return Container(
                              height: 50,
                              width: 50,
                              child: StyledLoader(),
                            );
                          });
                    },
                  );
                else
                  return Container(
                    //height: 190,
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
                  );
              })
        ],
      ),
    );
  }
}
