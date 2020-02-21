class Notification {
  final String id;
  final String message;
  final DateTime createdAt;

  const Notification({
    this.id,
    this.message,
    this.createdAt,
  });

  Notification.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        message = json['message'],
        createdAt = DateTime.parse(json['createdAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'createdAt': createdAt?.toString(),
      };
}
