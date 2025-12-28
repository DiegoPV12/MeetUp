import '../models/activity_model.dart';
import 'showcase_data.dart';

class ActivityService {
  Future<List<ActivityModel>> getByEvent(String eventId) async {
    return ShowcaseData.activities
        .where((activity) => activity.eventId == eventId)
        .toList();
  }

  Future<void> create(ActivityModel activity) async {
    ShowcaseData.activities.add(
      ActivityModel(
        id: ShowcaseData.nextActivityId(),
        name: activity.name,
        description: activity.description,
        location: activity.location,
        startTime: activity.startTime,
        endTime: activity.endTime,
        eventId: activity.eventId,
      ),
    );
  }

  Future<void> update(ActivityModel activity) async {
    final index = ShowcaseData.activities
        .indexWhere((existing) => existing.id == activity.id);
    if (index == -1) return;
    ShowcaseData.activities[index] = activity;
  }

  Future<void> delete(String id) async {
    ShowcaseData.activities.removeWhere((activity) => activity.id == id);
  }
}
