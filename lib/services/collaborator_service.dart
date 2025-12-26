import 'package:meetup/models/collaborator_model.dart';
import '../models/event_model.dart';
import 'showcase_data.dart';

class CollaboratorService {
  Future<List<CollaboratorModel>> getAllUsers() async {
    return ShowcaseData.collaborators;
  }

  Future<List<CollaboratorModel>> getEventCollaborators(String eventId) async {
    final event = ShowcaseData.findEvent(eventId);
    if (event == null) return [];

    return ShowcaseData.collaborators
        .where((user) => event.collaborators.contains(user.id))
        .toList();
  }

  Future<void> addCollaborator(String eventId, String userId) async {
    final index = ShowcaseData.findEventIndex(eventId);
    if (index == -1) return;

    final event = ShowcaseData.events[index];
    if (event.collaborators.contains(userId)) return;
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
      isCancelled: event.isCancelled,
      budget: event.budget,
      collaborators: [...event.collaborators, userId],
    );
  }

  Future<void> removeCollaborator(String eventId, String userId) async {
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
      isCancelled: event.isCancelled,
      budget: event.budget,
      collaborators:
          event.collaborators.where((id) => id != userId).toList(),
    );
  }
}
