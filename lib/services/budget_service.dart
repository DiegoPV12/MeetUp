import 'package:flutter/rendering.dart';
import '../models/event_model.dart';
import 'showcase_data.dart';

class BudgetService {
  Future<void> updateBudget(String eventId, double totalBudget) async {
    final index = ShowcaseData.findEventIndex(eventId);
    if (index == -1) {
      throw Exception('Evento no encontrado');
    }

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
      budget: totalBudget,
      collaborators: event.collaborators,
    );
    debugPrint('Presupuesto actualizado en modo showcase');
  }
}
