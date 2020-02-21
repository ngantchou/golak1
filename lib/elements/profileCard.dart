import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/models/user.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/utils/storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_image/network.dart';

class ProfileCard extends StatelessWidget {
  ProfileCard({
    Key key,
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.image,
  });
  final String name;
  final String email;
  final String phone;
  final String image;
  @override
  Widget build(BuildContext context) {
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final User user = authenticationNotifier.user;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
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
      child: Row(
        children: <Widget>[
          SizedBox(width: 16),
          InkWell(
            onTap: () async {
              final Storage _storage = Storage();
              String filePath = await _storage.pickImage();
              if (filePath != null) {
                final String url = await _storage.uploadImage(
                  type: 'image',
                  filePath: filePath,
                  extension: filePath.split('.').last,
                );
                await authenticationNotifier.updateProfilePicture(
                  userId: user.id,
                  picture: url,
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(104),
                border: Border.all(
                  width: 3,
                  color: Color(0xFF76D0B7),
                ),
              ),
              width: 104,
              height: 104,
              child: ClipOval(
                child: image != null
                    ? FadeInImage(
                        placeholder: AssetImage(
                          'images/person.jpg',
                        ),
                        image: NetworkImageWithRetry(
                          image,
                        ),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.add_a_photo,
                        color: Color(0xFF76D0B7),
                      ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text: '${FlutterI18n.translate(context, "name")} : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '$name',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text: '${FlutterI18n.translate(context, "email")} : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '$email',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text: '${FlutterI18n.translate(context, "ph_no")} :',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '$phone',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
