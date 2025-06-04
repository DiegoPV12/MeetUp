class EventRequest {
  final String name;
  final String description;
  final String location;
  final String category;
  final DateTime startTime;
  final DateTime? endTime;
  final String imageUrl;
  final List<String> collaborators;

  EventRequest({
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.startTime,
    this.endTime,
    required this.imageUrl,
    this.collaborators = const [],
  });

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'description': description,
      'location': location,
      'category': category,
      'startTime': startTime.toIso8601String(),
      'imageUrl': imageUrl,
      'budget': 0.0,
      'collaborators': collaborators,
    };

    if (endTime != null) {
      data['endTime'] = endTime!.toIso8601String();
    }

    return data;
  }
}
