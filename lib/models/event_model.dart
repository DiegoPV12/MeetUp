class EventModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String category;
  final DateTime startTime;
  final DateTime? endTime;
  final String? imageUrl;
  final String createdBy;
  final bool? isCancelled;
  final double? budget;
  final List<String> collaborators;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.startTime,
    this.endTime,
    this.imageUrl,
    required this.createdBy,
    this.isCancelled,
    this.budget,
    this.collaborators = const [],
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    print('Recibiendo json del evento: $json');

    double? parsedBudget;
    try {
      final rawBudget = json['budget'];
      if (rawBudget != null) {
        parsedBudget = (rawBudget as num).toDouble();
      }
    } catch (_) {
      parsedBudget = null;
    }

    final collaboratorList =
        (json['collaborators'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

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
      budget: parsedBudget,
      collaborators: collaboratorList,
    );
  }
}
