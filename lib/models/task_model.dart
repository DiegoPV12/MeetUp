class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String eventId;
  final AssignedUser? assignedTo;

  ///  `status` es mutable en la lógica actual, por eso lo mantenemos `var`
  ///  (si prefieres inmutabilidad total, quítale el `var` y usa sólo copyWith)
  String status;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.eventId,
    this.assignedTo,
  });

  /* ─────────────── JSON ─────────────── */
  factory TaskModel.fromJson(Map<String, dynamic> j) => TaskModel(
    id: j['_id'],
    title: j['title'],
    description: j['description'],
    status: j['status'],
    eventId: j['event'],
    assignedTo:
        j['assignedTo'] != null ? AssignedUser.fromJson(j['assignedTo']) : null,
  );

  /* ─────────────── copyWith ─────────────── */
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? eventId,
    AssignedUser? assignedTo,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      eventId: eventId ?? this.eventId,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}

class AssignedUser {
  final String id;
  final String name;
  final String email;

  AssignedUser({required this.id, required this.name, required this.email});

  factory AssignedUser.fromJson(Map<String, dynamic> j) =>
      AssignedUser(id: j['_id'], name: j['name'], email: j['email']);
}
