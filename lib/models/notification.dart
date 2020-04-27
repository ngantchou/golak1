class Notification {
   String id;
  final String message;
  bool seen;
  final String concern_user;
  final DateTime created_at;
  final DateTime updated_at;

   Notification({
    this.id,
    this.message,
    this.seen,
    this.concern_user,
    this.created_at,
    this.updated_at,
  });

  Notification.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        message = json['message'],
        seen = json['seen'],
        concern_user = json['concern_user'],
        created_at = DateTime.parse(json['created_at']),
        updated_at = DateTime.parse(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'seen': seen,
        'concern_user': concern_user,
        'created_at': created_at?.toString(),
        'updated_at': updated_at?.toString(),
      };
}
