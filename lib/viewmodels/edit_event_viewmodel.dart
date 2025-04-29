import 'package:flutter/material.dart';
import 'package:meetup/models/event_model.dart';
import '../services/event_service.dart';

class EditEventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  EventModel? _event;
  EventModel? get event => _event;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadEvent(String eventId) async {
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

  Future<void> updateEvent(
    String eventId,
    Map<String, dynamic> updatedData,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _eventService.updateEvent(eventId, updatedData);
      _event = await _eventService.fetchEventById(eventId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
