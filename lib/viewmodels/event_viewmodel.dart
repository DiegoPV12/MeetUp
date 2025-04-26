import 'package:flutter/material.dart';
import '../models/event_request_model.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<EventModel> _events = [];
  List<EventModel> get events => _events;

  Future<void> createEvent({
    required String name,
    required String description,
    required String location,
    required String category,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final eventRequest = EventRequest(
        name: name,
        description: description,
        location: location,
        category: category,
        startTime: startTime,
        endTime: endTime,
      );
      await _eventService.createEvent(eventRequest);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = await _eventService.fetchEvents();
    } catch (e) {
      _events = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
