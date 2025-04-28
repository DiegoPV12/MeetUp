class EventModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String category;
  final DateTime startTime;
  final DateTime? endTime;
  final String? imageUrl; // Ahora opcional
  final String createdBy;
  final bool? isCancelled; // Ahora opcional

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.startTime,
    this.endTime,
    this.imageUrl, // Opcional
    required this.createdBy,
    this.isCancelled, // Opcional
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    print('Recibiendo json del evento: $json');
    return EventModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      imageUrl: json['imageUrl'],
      createdBy: json['createdBy'] ?? '',
      isCancelled: json['isCancelled'],
    );
  }
}
