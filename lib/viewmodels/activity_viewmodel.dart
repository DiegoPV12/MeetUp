import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../services/activity_service.dart';

class ActivityViewModel extends ChangeNotifier {
  final _service = ActivityService();
  List<ActivityModel> _activities = [];
  bool isLoading = false;

  List<ActivityModel> get activities => _activities;

  Future<void> load(String eventId) async {
    isLoading = true;
    notifyListeners();
    _activities = await _service.getByEvent(eventId);

    // Ordenar por fecha de inicio
    _activities.sort((a, b) => a.startTime.compareTo(b.startTime));

    isLoading = false;
    notifyListeners();
  }

  Future<void> add(ActivityModel activity) async {
    await _service.create(activity);
    await load(activity.eventId);
  }

  Future<void> edit(ActivityModel activity) async {
    await _service.update(activity);
    await load(activity.eventId);
  }

  Future<void> remove(String id, String eventId) async {
    await _service.delete(id);
    await load(eventId);
  }
}
