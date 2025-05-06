class TaskModel {
  final String id;
  final String title;
  final String? description;
  String status;
  final String eventId;
  final AssignedUser? assignedTo;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.eventId,
    this.assignedTo,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['_id'],
    title: json['title'],
    description: json['description'],
    status: json['status'],
    eventId: json['event'],
    assignedTo:
        json['assignedTo'] != null
            ? AssignedUser.fromJson(json['assignedTo'])
            : null,
  );
}

class AssignedUser {
  final String id;
  final String name;
  final String email;

  AssignedUser({required this.id, required this.name, required this.email});

  factory AssignedUser.fromJson(Map<String, dynamic> json) =>
      AssignedUser(id: json['_id'], name: json['name'], email: json['email']);
}
