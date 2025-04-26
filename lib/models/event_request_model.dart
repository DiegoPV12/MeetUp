class EventRequest {
  final String name;
  final String description;
  final String location;
  final String category;
  final DateTime startTime;
  final DateTime endTime;

  EventRequest({
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'location': location,
    'category': category,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
  };
}
