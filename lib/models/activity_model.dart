class ActivityModel {
  final String id;
  final String name;
  final String description;
  final String location; // ← nuevo campo
  final DateTime startTime;
  final DateTime endTime;
  final String eventId;

  ActivityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.eventId,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      location: json['location'], // ← nuevo campo
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      eventId: json['event'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'location': location, // ← nuevo campo
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'event': eventId,
  };
}
