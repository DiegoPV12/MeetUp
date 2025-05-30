class GuestModel {
  final String id;
  final String name;
  final String email;
  final String status; // 'pending' | 'confirmed' | 'declined'
  final String eventId;

  // ── campos auxiliares opcionales ───────────────────────────
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool invitationSent;
  final bool isVip;

  GuestModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.eventId,
    //
    DateTime? createdAt,
    DateTime? updatedAt,
    this.invitationSent = false,
    this.isVip = false,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  // ---------- JSON  ----------
  factory GuestModel.fromJson(Map<String, dynamic> j) => GuestModel(
    id: j['_id'],
    name: j['name'],
    email: j['email'],
    status: j['status'],
    eventId: j['event'],
    createdAt: j['createdAt'] == null ? null : DateTime.parse(j['createdAt']),
    updatedAt: j['updatedAt'] == null ? null : DateTime.parse(j['updatedAt']),
    invitationSent: j['invitationSent'] ?? false,
    isVip: j['isVip'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'status': status,
    'event': eventId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'invitationSent': invitationSent,
    'isVip': isVip,
  };

  // ---------- copyWith  ----------
  GuestModel copyWith({
    String? name,
    String? email,
    String? status,
    DateTime? updatedAt,
    bool? invitationSent,
    bool? isVip,
  }) => GuestModel(
    id: id, // nunca cambia
    name: name ?? this.name,
    email: email ?? this.email,
    status: status ?? this.status,
    eventId: eventId, // nunca cambia
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    invitationSent: invitationSent ?? this.invitationSent,
    isVip: isVip ?? this.isVip,
  );
}
