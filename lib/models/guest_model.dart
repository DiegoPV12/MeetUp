class GuestModel {
  final String id;
  final String name;
  final String email;
  String status;
  final String eventId;

  GuestModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.eventId,
  });

  factory GuestModel.fromJson(Map<String, dynamic> json) => GuestModel(
    id: json['_id'],
    name: json['name'],
    email: json['email'],
    status: json['status'],
    eventId: json['event'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'status': status,
    'event': eventId,
  };
}
