import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String country;
  final String image;
  final String playerId;
  bool isPay;
  int _order;



  User({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.country,
    this.image,
    this.playerId,
    this.isPay,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        email = json['email'],
        phone = json['phone'].toString(),
        country = json['country'],
        image = json['image'],
        isPay = json['ispay'],
        playerId = json['playerId'],
        id = json['id'];

  int get order => _order;

  set order(int value) {
    _order = value;
  }


  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'phone': phone,
        'country': country,
        'image': image,
        'playerId': null,
        'ispay': isPay,
      };

  static User fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, phone: $phone, country: $country, image: $image, isPay: $isPay}';
  }

}
