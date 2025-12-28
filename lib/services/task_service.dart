import '../models/task_model.dart';
import 'showcase_data.dart';

class TaskService {
  Future<List<TaskModel>> getTasksByEvent(String eventId) async {
    return ShowcaseData.tasks
        .where((task) => task.eventId == eventId)
        .toList();
  }

  Future<void> createTask(
    String eventId,
    String title,
    String description,
  ) async {
    final event = ShowcaseData.findEvent(eventId);
    ShowcaseData.tasks.add(
      TaskModel(
        id: ShowcaseData.nextTaskId(),
        title: title,
        description: description,
        status: 'pending',
        eventId: eventId,
        eventName: event?.name ?? 'Evento',
      ),
    );
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    final index =
        ShowcaseData.tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) return;
    ShowcaseData.tasks[index] =
        ShowcaseData.tasks[index].copyWith(status: status);
  }

  Future<void> deleteTask(String taskId) async {
    ShowcaseData.tasks.removeWhere((task) => task.id == taskId);
  }

  Future<void> editTask(String taskId, String title, String description) async {
    final index =
        ShowcaseData.tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) return;
    final existing = ShowcaseData.tasks[index];
    ShowcaseData.tasks[index] = TaskModel(
      id: existing.id,
      title: title,
      description: description,
      status: existing.status,
      eventId: existing.eventId,
      eventName: existing.eventName,
      assignedUserId: existing.assignedUserId,
      assignedUserName: existing.assignedUserName,
      assignedUserEmail: existing.assignedUserEmail,
    );
  }

  Future<void> assignTaskToUser(String taskId, String userId) async {
    final index =
        ShowcaseData.tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) return;
    final user = ShowcaseData.collaborators
        .firstWhere((collaborator) => collaborator.id == userId);
    final existing = ShowcaseData.tasks[index];
    ShowcaseData.tasks[index] = TaskModel(
      id: existing.id,
      title: existing.title,
      description: existing.description,
      status: existing.status,
      eventId: existing.eventId,
      eventName: existing.eventName,
      assignedUserId: user.id,
      assignedUserName: user.name,
      assignedUserEmail: user.email,
    );
  }

  Future<void> unassignTask(String taskId) async {
    final index =
        ShowcaseData.tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) return;
    final existing = ShowcaseData.tasks[index];
    ShowcaseData.tasks[index] = TaskModel(
      id: existing.id,
      title: existing.title,
      description: existing.description,
      status: existing.status,
      eventId: existing.eventId,
      eventName: existing.eventName,
      assignedUserId: null,
      assignedUserName: null,
      assignedUserEmail: null,
    );
  }
}
