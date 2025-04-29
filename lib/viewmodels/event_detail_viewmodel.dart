import 'package:flutter/material.dart';
import 'package:meetup/models/event_model.dart';
import '../services/event_service.dart';

class EventDetailViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  EventModel? _event;
  EventModel? get event => _event;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchEventDetail(String eventId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _event = await _eventService.fetchEventById(eventId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventService.deleteEvent(eventId);
  }

  Future<void> toggleCancelEvent(
    String eventId, {
    required bool isCurrentlyCancelled,
  }) async {
    await _eventService.toggleCancelEvent(
      eventId,
      isCurrentlyCancelled: isCurrentlyCancelled,
    );

    if (_event != null && _event!.id == eventId) {
      _event = EventModel(
        id: _event!.id,
        name: _event!.name,
        description: _event!.description,
        location: _event!.location,
        category: _event!.category,
        startTime: _event!.startTime,
        endTime: _event!.endTime,
        imageUrl: _event!.imageUrl,
        createdBy: _event!.createdBy,
        isCancelled: !isCurrentlyCancelled,
      );
      notifyListeners();
    }
  }
}
