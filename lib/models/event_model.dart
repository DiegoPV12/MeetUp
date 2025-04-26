class EventModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String category;
  final DateTime startTime;
  final DateTime endTime;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.startTime,
    required this.endTime,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}
