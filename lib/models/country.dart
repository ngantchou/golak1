class Country {
  final String code;
  final String name;
  final bool eu;

  const Country({
    this.code,
    this.name,
    this.eu,
  });

  Country.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = json['name'],
        eu = json['eu'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'eu': eu,
      };
}
