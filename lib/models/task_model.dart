class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String eventId;
  final String eventName;
  final String? assignedUserId;
  final String? assignedUserName;
  final String? assignedUserEmail;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.eventId,
    required this.eventName,
    this.assignedUserId,
    this.assignedUserName,
    this.assignedUserEmail,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final event = json['event'] ?? {};
    final assignedTo = json['assignedTo'];

    return TaskModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      eventId: event['_id'] ?? '',
      eventName: event['name'] ?? '',
      assignedUserId: assignedTo != null ? assignedTo['_id'] : null,
      assignedUserName: assignedTo != null ? assignedTo['name'] : null,
      assignedUserEmail: assignedTo != null ? assignedTo['email'] : null,
    );
  }

  TaskModel copyWith({
    String? status,
  }) {
    return TaskModel(
      id: id,
      title: title,
      description: description,
      status: status ?? this.status,
      eventId: eventId,
      eventName: eventName,
      assignedUserId: assignedUserId,
      assignedUserName: assignedUserName,
      assignedUserEmail: assignedUserEmail,
    );
  }
}
