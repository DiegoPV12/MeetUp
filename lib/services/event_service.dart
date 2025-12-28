import 'package:meetup/models/event_request_model.dart';
import '../models/event_model.dart';
import 'showcase_data.dart';

class EventService {
  Future<String> createEvent(EventRequest request) async {
    final eventId = ShowcaseData.nextEventId();
    final event = EventModel(
      id: eventId,
      name: request.name,
      description: request.description,
      location: request.location,
      category: request.category,
      startTime: request.startTime,
      endTime: request.endTime,
      imageUrl: request.imageUrl,
      createdBy: ShowcaseData.currentUser.id,
      budget: 0,
      collaborators: request.collaborators,
    );
    ShowcaseData.events.add(event);
    return eventId;
  }

  Future<List<EventModel>> fetchEvents() async {
    return List<EventModel>.from(ShowcaseData.events);
  }

  Future<EventModel> fetchEventById(String eventId, bool isCollaborator) async {
    final event = ShowcaseData.findEvent(eventId);
    if (event == null) {
      throw Exception('Evento no encontrado');
    }
    return event;
  }

  Future<void> deleteEvent(String eventId) async {
    ShowcaseData.events.removeWhere((event) => event.id == eventId);
  }

  Future<void> toggleCancelEvent(
    String eventId, {
    required bool isCurrentlyCancelled,
  }) async {
    final index = ShowcaseData.findEventIndex(eventId);
    if (index == -1) return;

    final event = ShowcaseData.events[index];
    ShowcaseData.events[index] = EventModel(
      id: event.id,
      name: event.name,
      description: event.description,
      location: event.location,
      category: event.category,
      startTime: event.startTime,
      endTime: event.endTime,
      imageUrl: event.imageUrl,
      createdBy: event.createdBy,
      isCancelled: !isCurrentlyCancelled,
      budget: event.budget,
      collaborators: event.collaborators,
    );
  }

  Future<List<EventModel>> fetchEventsAsCollaborator() async {
    return ShowcaseData.events
        .where((event) => event.collaborators.contains(ShowcaseData.currentUser.id))
        .toList();
  }

  Future<void> updateEvent(
    String eventId,
    Map<String, dynamic> updatedData,
  ) async {
    final index = ShowcaseData.findEventIndex(eventId);
    if (index == -1) return;

    final event = ShowcaseData.events[index];
    final startTime = updatedData['startTime'] is String
        ? DateTime.parse(updatedData['startTime'] as String)
        : updatedData['startTime'] ?? event.startTime;
    final endTime = updatedData['endTime'] is String
        ? DateTime.parse(updatedData['endTime'] as String)
        : updatedData['endTime'] ?? event.endTime;
    ShowcaseData.events[index] = EventModel(
      id: event.id,
      name: updatedData['name'] ?? event.name,
      description: updatedData['description'] ?? event.description,
      location: updatedData['location'] ?? event.location,
      category: updatedData['category'] ?? event.category,
      startTime: startTime,
      endTime: endTime,
      imageUrl: updatedData['imageUrl'] ?? event.imageUrl,
      createdBy: event.createdBy,
      isCancelled: event.isCancelled,
      budget: updatedData['budget'] ?? event.budget,
      collaborators: updatedData['collaborators'] ?? event.collaborators,
    );
  }
}
