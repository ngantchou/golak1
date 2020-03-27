class User {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String country;
  final String image;
  final bool isPay;

  const User({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.country,
    this.image,
    this.isPay,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        email = json['email'],
        phone = json['phone'],
        country = json['country'],
        image = json['image'],
        isPay = json['ispay'],
        id = json['_id'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'phone': phone,
        'country': country,
        'image': image,
        'ispay': isPay,
      };
}
